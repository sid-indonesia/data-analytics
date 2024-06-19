"""signal module
The signal module contains a wrapper class for temporal signals
"""
import numpy as np


class Samples:
    """Data class of a signal of samples

    Data class containing a list of timestamp and of signal values

    Attributes
    ----------
    timestamps : array of floats (n,)
        Timestamps of the samples
    values : array of floats (n,)
        Values of the samples
    """

    def __init__(self, timestamps: np.ndarray, pixels: np.ndarray):
        if timestamps.ndim != 1:
            raise ValueError("Timestamps should be 1-dimensional")
        if not 3 <= pixels.ndim <= 4:
            raise ValueError("Values should be 3 or 4-dimensional")
        if len(timestamps) != pixels.shape[0]:
            raise ValueError("Timestamps and values should have the same length")

        self.__timestamps = timestamps
        # Casts the pixels to be 4 dimensional if they are in gray scale
        if pixels.ndim == 3:
            new_shape = pixels.shape + (1,)
            self.__pixels = np.reshape(pixels, new_shape)
        else:
            self.__pixels = pixels

        self.__length = pixels.shape[0]
        self.__fs = (
            1.0 / np.median(np.diff(timestamps)) if len(timestamps) > 0 else np.nan
        )
        self.recording_start = self.__timestamps[0]
        self.start_date = 0

    @property
    def timestamps(self):
        """timestamps timestamps of the samples"""
        return self.__timestamps

    @property
    def pixels(self):
        """pixels Pixel values of the samples"""
        return self.__pixels

    @property
    def width(self):
        """width Samples width"""
        return self.__pixels.shape[1]

    @property
    def height(self):
        """height Samples height"""
        return self.__pixels.shape[2]

    @property
    def channels(self):
        """channels Samples number of channels"""
        return self.__pixels.shape[3]

    @property
    def fs(self):
        """fs Sampling frequency of the samples"""
        return self.__fs

    @property
    def size(self):
        """size Samples number"""
        return self.__length
