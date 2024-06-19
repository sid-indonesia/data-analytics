from libc.stdint cimport *
from libc.string cimport *
from cpython.ref cimport PyObject

from pyrobuf_list cimport *
from pyrobuf_util cimport *

import json

cdef enum _Result:
    _Result_SUCCESS = 0
    _Result_OBPM_FAIL = 2
    _Result_QUALITY_THRESHOLD = 3
    _Result_UNKNOWN = 4

cdef class Sample:


    cdef double _timestamp
    cpdef _timestamp__reset(self)
    cdef FloatList _pixels
    cpdef _pixels__reset(self)


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef object _listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, Sample other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, Sample other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef void _clearfield(self, field_name)
    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)

cdef class RecordingData:


    cdef _Result _result
    cpdef _result__reset(self)
    cdef int64_t _start
    cpdef _start__reset(self)
    cdef double _recordingStart
    cpdef _recordingStart__reset(self)
    cdef int32_t _sampleWidth
    cpdef _sampleWidth__reset(self)
    cdef int32_t _sampleHeight
    cpdef _sampleHeight__reset(self)
    cdef TypedList _samples
    cpdef _samples__reset(self)


    cdef uint64_t __field_bitmap0

    cdef public bint _is_present_in_parent
    cdef bytes _cached_serialization

    cdef object _listener

    cpdef void reset(self)

    cpdef void Clear(self)
    cpdef void ClearField(self, field_name)
    cpdef void CopyFrom(self, RecordingData other_msg)
    cpdef bint HasField(self, field_name) except -1
    cpdef bint IsInitialized(self)
    cpdef void MergeFrom(self, RecordingData other_msg)
    cpdef int MergeFromString(self, data, size=*) except -1
    cpdef int ParseFromString(self, data, size=*, bint reset=*, bint cache=*) except -1
    cpdef bytes SerializeToString(self, bint cache=*)
    cpdef bytes SerializePartialToString(self)

    cdef void _clearfield(self, field_name)
    cdef int _protobuf_deserialize(self, const unsigned char *memory, int size, bint cache)

    cdef void _protobuf_serialize(self, bytearray buf, bint cache)

    cpdef void _Modified(self)