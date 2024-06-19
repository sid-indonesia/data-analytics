from libc.stdint cimport *
from libc.string cimport *

from pyrobuf_list cimport *
from pyrobuf_util cimport *

import base64
import json
import warnings

class DecodeError(Exception):
    pass

cdef class Sample:

    def __cinit__(self):
        self._listener = noop_listener

    def __dealloc__(self):
        # Remove any references to self from child messages or repeated fields
        if self._pixels is not None:
            self._pixels._listener = noop_listener

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    if field_name in ('pixels',):
                        getattr(self, field_name).extend(field_value)
                    else:
                        setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'timestamp',
                          'pixels',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = []
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    
    cpdef _timestamp__reset(self):
        self._timestamp = 0
        self.__field_bitmap0 &= ~1
    cpdef _pixels__reset(self):
        if self._pixels is not None:
            self._pixels._listener = noop_listener
        self._pixels = FloatList.__new__(FloatList)
        self._pixels._listener = self._Modified

    cpdef void reset(self):
        # reset values and populate defaults
    
        self._timestamp__reset()
        self._pixels__reset()
        return

    
    @property
    def timestamp(self):
        return self._timestamp

    @timestamp.setter
    def timestamp(self, value):
        self.__field_bitmap0 |= 1
        self._timestamp = value
        self._Modified()
    
    @property
    def pixels(self):
        return self._pixels

    @pixels.setter
    def pixels(self, value):
        if self._pixels is not None:
            self._pixels._listener = noop_listener
        cdef float[:] memview
        cdef int memview_available = 0
        try:
            memview = value
            memview_available = 1
        except (TypeError, NameError, ValueError):
            pass
        cdef int i
        if memview_available == 1:
            self._pixels = FloatList(memview.size, listener=self._Modified)
            for i in range(memview.size):
                self._pixels.append(memview[i])
            return
        self._pixels = FloatList(listener=self._Modified)
        for val in value:
            self._pixels.append(val)
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        cdef int64_t pixels_marker
        cdef float pixels_elt
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # timestamp
            if key == 9:
                self.__field_bitmap0 |= 1
                self._timestamp = (<double *>&memory[current_offset])[0]
                current_offset += sizeof(double)
            # pixels
            elif key == 18:
                pixels_marker = get_varint64(memory, &current_offset)
                pixels_marker += current_offset

                while current_offset < <int>pixels_marker:
                    pixels_elt = (<float *>&memory[current_offset])[0]
                    current_offset += sizeof(float)
                    self._pixels._append(pixels_elt)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        self._clearfield(field_name)
        self._Modified()

    cdef void _clearfield(self, field_name):
        if field_name == 'timestamp':
            self._timestamp__reset()
        elif field_name == 'pixels':
            self._pixels__reset()
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

    cpdef void CopyFrom(self, Sample other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (Sample): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'timestamp':
            return self.__field_bitmap0 & 1 == 1
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """

    

        return True

    cpdef void MergeFrom(self, Sample other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """
        cdef int i

        if self is other_msg:
            return

    
        if other_msg.__field_bitmap0 & 1 == 1:
            self._timestamp = other_msg._timestamp
            self.__field_bitmap0 |= 1
        self._pixels.extend(other_msg._pixels)

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        cdef ssize_t length
        # timestamp
        if self.__field_bitmap0 & 1 == 1:
            set_varint64(9, buf)
            buf += (<unsigned char *>&self._timestamp)[:sizeof(double)]
        # pixels
        cdef float pixels_elt
        length = len(self._pixels)
        if length > 0:
            set_varint64(18, buf)
            set_varint64(length * sizeof(float), buf)
            for pixels_elt in self._pixels:
                buf += (<unsigned char *>&pixels_elt)[:sizeof(float)]

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        self._listener()
        self._cached_serialization = None

    

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """

    

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.timestamp = d["timestamp"]
        except KeyError:
            pass
        try:
            self.pixels = d["pixels"]
        except KeyError:
            pass

        self._Modified()

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["timestamp"] = self.timestamp
        if len(self.pixels) > 0:
            out["pixels"] = list(self.pixels)

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["timestamp"] = self.timestamp
        if len(self.pixels) > 0:
            out["pixels"] = list(self.pixels)

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'timestamp', self.timestamp
        yield 'pixels', self.pixels

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'timestamp'
        yield 'pixels'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.timestamp
        yield self.pixels

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.timestamp = value
        yield setter
        def setter(value):
            self.pixels = value
        yield setter

    


cdef class RecordingData:

    def __cinit__(self):
        self._listener = noop_listener

    def __dealloc__(self):
        # Remove any references to self from child messages or repeated fields
        if self._samples is not None:
            self._samples._listener = noop_listener

    def __init__(self, **kwargs):
        self.reset()
        if kwargs:
            for field_name, field_value in kwargs.items():
                try:
                    if field_name in ('samples',):
                        getattr(self, field_name).extend(field_value)
                    else:
                        setattr(self, field_name, field_value)
                except AttributeError:
                    raise ValueError('Protocol message has no "%s" field.' % (field_name,))
        return

    def __str__(self):
        fields = [
                          'result',
                          'start',
                          'recordingStart',
                          'sampleWidth',
                          'sampleHeight',]
        components = ['{0}: {1}'.format(field, getattr(self, field)) for field in fields]
        messages = [
                            'samples',]
        for message in messages:
            components.append('{0}: {{'.format(message))
            for line in str(getattr(self, message)).split('\n'):
                components.append('  {0}'.format(line))
            components.append('}')
        return '\n'.join(components)

    
    cpdef _result__reset(self):
        self._result = _Result_SUCCESS
        self.__field_bitmap0 &= ~1
    cpdef _start__reset(self):
        self._start = 0
        self.__field_bitmap0 &= ~2
    cpdef _recordingStart__reset(self):
        self._recordingStart = 0
        self.__field_bitmap0 &= ~4
    cpdef _sampleWidth__reset(self):
        self._sampleWidth = 0
        self.__field_bitmap0 &= ~8
    cpdef _sampleHeight__reset(self):
        self._sampleHeight = 0
        self.__field_bitmap0 &= ~16
    cpdef _samples__reset(self):
        if self._samples is not None:
            self._samples._listener = noop_listener
        self._samples = TypedList.__new__(TypedList)
        self._samples._list_type = Sample
        self._samples._listener = self._Modified

    cpdef void reset(self):
        # reset values and populate defaults
    
        self._result__reset()
        self._start__reset()
        self._recordingStart__reset()
        self._sampleWidth__reset()
        self._sampleHeight__reset()
        self._samples__reset()
        return

    
    @property
    def result(self):
        return self._result

    @result.setter
    def result(self, value):
        self.__field_bitmap0 |= 1
        if value == 0:
            self._result = _Result_SUCCESS
                
        elif value == 2:
            self._result = _Result_OBPM_FAIL
                
        elif value == 3:
            self._result = _Result_QUALITY_THRESHOLD
                
        elif value == 4:
            self._result = _Result_UNKNOWN
                
        else:
            raise ValueError("{} not a valid value for enum Result".format(value))
        self._Modified()
    
    @property
    def start(self):
        return self._start

    @start.setter
    def start(self, value):
        self.__field_bitmap0 |= 2
        self._start = value
        self._Modified()
    
    @property
    def recordingStart(self):
        return self._recordingStart

    @recordingStart.setter
    def recordingStart(self, value):
        self.__field_bitmap0 |= 4
        self._recordingStart = value
        self._Modified()
    
    @property
    def sampleWidth(self):
        return self._sampleWidth

    @sampleWidth.setter
    def sampleWidth(self, value):
        self.__field_bitmap0 |= 8
        self._sampleWidth = value
        self._Modified()
    
    @property
    def sampleHeight(self):
        return self._sampleHeight

    @sampleHeight.setter
    def sampleHeight(self, value):
        self.__field_bitmap0 |= 16
        self._sampleHeight = value
        self._Modified()
    
    @property
    def samples(self):
        # lazy init sub messages
        if self._samples is None:
            self._samples = Sample.__new__(Sample)
            self._samples.reset()
            self._samples._listener = self._Modified
            self._listener()
        return self._samples

    @samples.setter
    def samples(self, value):
        if self._samples is not None:
            self._samples._listener = noop_listener
        self._samples = TypedList.__new__(TypedList)
        self._samples._list_type = Sample
        self._samples._listener = self._Modified
        for val in value:
            list.append(self._samples, val)
        self._Modified()
    

    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache):
        cdef int current_offset = 0
        cdef int64_t key
        cdef int64_t field_size
        cdef Sample samples_elt
        while current_offset < size:
            key = get_varint64(memory, &current_offset)
            # result
            if key == 8:
                self.result = get_varint32(memory, &current_offset)
            # start
            elif key == 16:
                self.__field_bitmap0 |= 2
                self._start = get_varint64(memory, &current_offset)
            # recordingStart
            elif key == 25:
                self.__field_bitmap0 |= 4
                self._recordingStart = (<double *>&memory[current_offset])[0]
                current_offset += sizeof(double)
            # sampleWidth
            elif key == 32:
                self.__field_bitmap0 |= 8
                self._sampleWidth = get_varint32(memory, &current_offset)
            # sampleHeight
            elif key == 40:
                self.__field_bitmap0 |= 16
                self._sampleHeight = get_varint32(memory, &current_offset)
            # samples
            elif key == 50:
                samples_elt = Sample.__new__(Sample)
                samples_elt.reset()
                field_size = get_varint64(memory, &current_offset)
                if cache:
                    samples_elt._cached_serialization = bytes(memory[current_offset:current_offset+field_size])
                current_offset += samples_elt._protobuf_deserialize(memory+current_offset, <int>field_size, cache)
                list.append(self._samples, samples_elt)
            # Unknown field - need to skip proper number of bytes
            else:
                assert skip_generic(memory, &current_offset, size, key & 0x7)

        self._is_present_in_parent = True

        return current_offset

    cpdef void Clear(self):
        """Clears all data that was set in the message."""
        self.reset()
        self._Modified()

    cpdef void ClearField(self, field_name):
        """Clears the contents of a given field."""
        self._clearfield(field_name)
        self._Modified()

    cdef void _clearfield(self, field_name):
        if field_name == 'result':
            self._result__reset()
        elif field_name == 'start':
            self._start__reset()
        elif field_name == 'recordingStart':
            self._recordingStart__reset()
        elif field_name == 'sampleWidth':
            self._sampleWidth__reset()
        elif field_name == 'sampleHeight':
            self._sampleHeight__reset()
        elif field_name == 'samples':
            self._samples__reset()
        else:
            raise ValueError('Protocol message has no "%s" field.' % field_name)

    cpdef void CopyFrom(self, RecordingData other_msg):
        """
        Copies the content of the specified message into the current message.

        Params:
            other_msg (RecordingData): Message to copy into the current one.
        """
        if self is other_msg:
            return
        self.reset()
        self.MergeFrom(other_msg)

    cpdef bint HasField(self, field_name) except -1:
        """
        Checks if a certain field is set for the message.

        Params:
            field_name (str): The name of the field to check.
        """
        if field_name == 'result':
            return self.__field_bitmap0 & 1 == 1
        if field_name == 'start':
            return self.__field_bitmap0 & 2 == 2
        if field_name == 'recordingStart':
            return self.__field_bitmap0 & 4 == 4
        if field_name == 'sampleWidth':
            return self.__field_bitmap0 & 8 == 8
        if field_name == 'sampleHeight':
            return self.__field_bitmap0 & 16 == 16
        raise ValueError('Protocol message has no singular "%s" field.' % field_name)

    cpdef bint IsInitialized(self):
        """
        Checks if the message is initialized.

        Returns:
            bool: True if the message is initialized (i.e. all of its required
                fields are set).
        """
        cdef int i
        cdef Sample samples_msg

    
        for i in range(len(self._samples)):
            samples_msg = <Sample>self._samples[i]
            if not samples_msg.IsInitialized():
                return False

        return True

    cpdef void MergeFrom(self, RecordingData other_msg):
        """
        Merges the contents of the specified message into the current message.

        Params:
            other_msg: Message to merge into the current message.
        """
        cdef int i
        cdef Sample samples_elt

        if self is other_msg:
            return

    
        if other_msg.__field_bitmap0 & 1 == 1:
            self._result = other_msg._result
            self.__field_bitmap0 |= 1
        if other_msg.__field_bitmap0 & 2 == 2:
            self._start = other_msg._start
            self.__field_bitmap0 |= 2
        if other_msg.__field_bitmap0 & 4 == 4:
            self._recordingStart = other_msg._recordingStart
            self.__field_bitmap0 |= 4
        if other_msg.__field_bitmap0 & 8 == 8:
            self._sampleWidth = other_msg._sampleWidth
            self.__field_bitmap0 |= 8
        if other_msg.__field_bitmap0 & 16 == 16:
            self._sampleHeight = other_msg._sampleHeight
            self.__field_bitmap0 |= 16
        for i in range(len(other_msg._samples)):
            samples_elt = Sample()
            samples_elt.MergeFrom(other_msg._samples[i])
            list.append(self._samples, samples_elt)

        self._Modified()

    cpdef int MergeFromString(self, data, size=None) except -1:
        """
        Merges serialized protocol buffer data into this message.

        Params:
            data (bytes): a string of binary data.
            size (int): optional - the length of the data string

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        buf = self._protobuf_deserialize(data, length, False)

        if buf != length:
            raise DecodeError("Truncated message: got %s expected %s" % (buf, size))

        self._Modified()

        return buf

    cpdef int ParseFromString(self, data, size=None, bint reset=True, bint cache=False) except -1:
        """
        Populate the message class from a string of protobuf encoded binary data.

        Params:
            data (bytes): a string of binary data
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
            cache (bool): optional - whether to cache serialized data

        Returns:
            int: the number of bytes processed during serialization
        """
        cdef int buf
        cdef int length

        length = size if size is not None else len(data)

        if reset:
            self.reset()

        buf = self._protobuf_deserialize(data, length, cache)

        if buf != length:
            raise DecodeError("Truncated message")

        self._Modified()

        if cache:
            self._cached_serialization = data

        return buf

    @classmethod
    def FromString(cls, s):
        message = cls()
        message.MergeFromString(s)
        return message

    cdef void _protobuf_serialize(self, bytearray buf, bint cache):
        cdef ssize_t length
        # result
        if self.__field_bitmap0 & 1 == 1:
            set_varint64(8, buf)
            set_varint32(self._result, buf)
        # start
        if self.__field_bitmap0 & 2 == 2:
            set_varint64(16, buf)
            set_varint64(self._start, buf)
        # recordingStart
        if self.__field_bitmap0 & 4 == 4:
            set_varint64(25, buf)
            buf += (<unsigned char *>&self._recordingStart)[:sizeof(double)]
        # sampleWidth
        if self.__field_bitmap0 & 8 == 8:
            set_varint64(32, buf)
            set_varint32(self._sampleWidth, buf)
        # sampleHeight
        if self.__field_bitmap0 & 16 == 16:
            set_varint64(40, buf)
            set_varint32(self._sampleHeight, buf)
        # samples
        cdef Sample samples_elt
        cdef bytearray samples_elt_buf
        for samples_elt in self._samples:
            set_varint64(50, buf)
            if samples_elt._cached_serialization is not None:
                set_varint64(len(samples_elt._cached_serialization), buf)
                buf += samples_elt._cached_serialization
            else:
                samples_elt_buf = bytearray()
                samples_elt._protobuf_serialize(samples_elt_buf, cache)
                set_varint64(len(samples_elt_buf), buf)
                buf += samples_elt_buf
                if cache:
                    samples_elt._cached_serialization = bytes(samples_elt_buf)

    cpdef void _Modified(self):
        self._is_present_in_parent = True
        self._listener()
        self._cached_serialization = None

    

    cpdef bytes SerializeToString(self, bint cache=False):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        cdef int i
        cdef Sample samples_msg

    
        for i in range(len(self._samples)):
            samples_msg = <Sample>self._samples[i]
            if not samples_msg.IsInitialized():
                raise Exception("Message RecordingData is missing required field: samples[%d]" % i)

        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, cache)
        cdef bytes out = bytes(buf)

        if cache:
            self._cached_serialization = out

        return out

    cpdef bytes SerializePartialToString(self):
        """
        Serialize the message class into a string of protobuf encoded binary data.

        Returns:
            bytes: a byte string of binary data
        """
        if self._cached_serialization is not None:
            return self._cached_serialization

        cdef bytearray buf = bytearray()
        self._protobuf_serialize(buf, False)
        return bytes(buf)

    def SetInParent(self):
        """
        Mark this an present in the parent.
        """
        self._Modified()

    def ParseFromJson(self, data, size=None, reset=True):
        """
        Populate the message class from a json string.

        Params:
            data (str): a json string
            size (int): optional - the length of the data string
            reset (bool): optional - whether to reset to default values before serializing
        """
        if size is None:
            size = len(data)
        d = json.loads(data[:size])
        self.ParseFromDict(d, reset)

    def SerializeToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializeToDict()
        return json.dumps(d, **kwargs)

    def SerializePartialToJson(self, **kwargs):
        """
        Serialize the message class into a json string.

        Returns:
            str: a json formatted string
        """
        d = self.SerializePartialToDict()
        return json.dumps(d, **kwargs)

    def ParseFromDict(self, d, reset=True):
        """
        Populate the message class from a Python dictionary.

        Params:
            d (dict): a Python dictionary representing the message
            reset (bool): optional - whether to reset to default values before serializing
        """
        if reset:
            self.reset()

        assert type(d) == dict
        try:
            self.result = d["result"]
        except KeyError:
            pass
        try:
            self.start = d["start"]
        except KeyError:
            pass
        try:
            self.recordingStart = d["recordingStart"]
        except KeyError:
            pass
        try:
            self.sampleWidth = d["sampleWidth"]
        except KeyError:
            pass
        try:
            self.sampleHeight = d["sampleHeight"]
        except KeyError:
            pass
        try:
            for samples_dict in d["samples"]:
                samples_elt = Sample()
                samples_elt.ParseFromDict(samples_dict)
                self.samples.append(samples_elt)
        except KeyError:
            pass

        self._Modified()

        return

    def SerializeToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["result"] = self.result
        if self.__field_bitmap0 & 2 == 2:
            out["start"] = self.start
        if self.__field_bitmap0 & 4 == 4:
            out["recordingStart"] = self.recordingStart
        if self.__field_bitmap0 & 8 == 8:
            out["sampleWidth"] = self.sampleWidth
        if self.__field_bitmap0 & 16 == 16:
            out["sampleHeight"] = self.sampleHeight
        if len(self.samples) > 0:
            out["samples"] = [m.SerializeToDict() for m in self.samples]

        return out

    def SerializePartialToDict(self):
        """
        Translate the message into a Python dictionary.

        Returns:
            dict: a Python dictionary representing the message
        """
        out = {}
        if self.__field_bitmap0 & 1 == 1:
            out["result"] = self.result
        if self.__field_bitmap0 & 2 == 2:
            out["start"] = self.start
        if self.__field_bitmap0 & 4 == 4:
            out["recordingStart"] = self.recordingStart
        if self.__field_bitmap0 & 8 == 8:
            out["sampleWidth"] = self.sampleWidth
        if self.__field_bitmap0 & 16 == 16:
            out["sampleHeight"] = self.sampleHeight
        if len(self.samples) > 0:
            out["samples"] = [m.SerializePartialToDict() for m in self.samples]

        return out

    def Items(self):
        """
        Iterator over the field names and values of the message.

        Returns:
            iterator
        """
        yield 'result', self.result
        yield 'start', self.start
        yield 'recordingStart', self.recordingStart
        yield 'sampleWidth', self.sampleWidth
        yield 'sampleHeight', self.sampleHeight
        yield 'samples', self.samples

    def Fields(self):
        """
        Iterator over the field names of the message.

        Returns:
            iterator
        """
        yield 'result'
        yield 'start'
        yield 'recordingStart'
        yield 'sampleWidth'
        yield 'sampleHeight'
        yield 'samples'

    def Values(self):
        """
        Iterator over the values of the message.

        Returns:
            iterator
        """
        yield self.result
        yield self.start
        yield self.recordingStart
        yield self.sampleWidth
        yield self.sampleHeight
        yield self.samples

    

    def Setters(self):
        """
        Iterator over functions to set the fields in a message.

        Returns:
            iterator
        """
        def setter(value):
            self.result = value
        yield setter
        def setter(value):
            self.start = value
        yield setter
        def setter(value):
            self.recordingStart = value
        yield setter
        def setter(value):
            self.sampleWidth = value
        yield setter
        def setter(value):
            self.sampleHeight = value
        yield setter
        def setter(value):
            self.samples = value
        yield setter

    


SUCCESS = _Result_SUCCESS
OBPM_FAIL = _Result_OBPM_FAIL
QUALITY_THRESHOLD = _Result_QUALITY_THRESHOLD
UNKNOWN = _Result_UNKNOWN