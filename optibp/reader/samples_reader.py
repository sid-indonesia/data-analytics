""" sample IO module

Utility module helping to read samples from the different formats.

Notes
-----
The legacy data.txt format is no longer supported
"""
from zipfile import Path, ZipFile

import numpy as np
from .samples import Samples
from . import MeasuringSessionReportProto_pb2 as MeasuringSession


def recording_data_to_samples(session: MeasuringSession.RecordingData) -> Samples:
    """Transforms a MSRP.RecordingData in a RGB object

    Parameters
    ----------
    session : MeasuringSession.RecordingData
        Session containing the data

    Returns
    -------
    Samples
        RGB object containing the data
    """
    # Gathers the samples data
    session_samples = session.samples
    timestamps = np.array([sample.timestamp for sample in session_samples]).astype(
        np.float64
    )
    pixels = np.array([np.array(sample.pixels) for sample in session_samples]).astype(
        np.float64
    )

    # Extracts the dimensions of the individual frames
    size = pixels.shape[1]
    width = session.sampleWidth
    height = session.sampleHeight
    channels = size // (height * width)

    # Checks compatibility with the actual individual frames
    if channels * height * width != size:
        raise ValueError(
            f"Number of pixel values {size} is incompatible with provided dimensions ({height}, {width}, {channels})"
        )

    # Converts to a sample object
    samples = Samples(
        timestamps,
        pixels.reshape((pixels.shape[0], height, width, channels)),
    )
    samples.recording_start = session.recordingStart
    samples.start_date = session.start
    return samples


def read_file(filename: str):
    """Reads data contained in a data.bin file

    Parameters
    ----------
    filename : str
        Path to the data.bin file

    Returns
    -------
    RGB
        RGB object containing the data
    """
    samples = None

    if filename.endswith(".bin"):
        try:
            samples = read_optibp(filename)
        except Exception as e:
            raise ValueError(
                "Input file could not be read. Please ensure it was encoded with 'MeasuringSessionReportProto' protobuffer format ('data.bin')."
            ) from e
    elif filename.endswith(".zip"):
        try:
            samples = read_zip(filename)
        except Exception as e:
            raise ValueError(
                "Input file could not be read. Please ensure the zip file contains a data.bin or a data.txt."
            ) from e
    else:
        raise ValueError(
            "Unknown format. Please use a 'data.txt' or a 'data.bin' format."
        )

    if samples is not None:
        return samples


def read_optibp(filename: str):
    """Reads data contained in a data.bin file

    Parameters
    ----------
    filename : str
        Path to the data.bin file

    Returns
    -------
    RGB
        RGB object containing the data
    """
    sr = MeasuringSession.RecordingData()
    with open(filename, "rb") as f:
        sr.ParseFromString(f.read())
    return recording_data_to_samples(sr)


def __read_bin(filename: Path):
    """Reads data contained in a data.bin file

    Parameters
    ----------
    filename : Path
        Abstract path to the data.bin file in the archive

    Returns
    -------
    RGB
        RGB object containing the data
    """
    sr = MeasuringSession.RecordingData()
    with filename.open("rb") as f:
        sr.ParseFromString(f.read())
    return recording_data_to_samples(sr)


def read_zip(filename: str):
    """Reads data contained in a zip file and creates a new RGB object

    Parameters
    ----------
    filename : str
        path to the zip file

    Returns
    -------
    RGB
        RGB object containing the data
    """

    # Checks if zip is already extracted
    if not filename.endswith("zip"):
        raise ValueError(f"Archive name `{filename}` should end with zip.")

    zip_entry = ZipFile(filename, "r")
    bin_path = Path(zip_entry, "data.bin")
    if bin_path.exists():
        rgb = __read_bin(bin_path)
    else:
        raise ValueError(f"No data.txt nor data.bin in the zip file at '{filename}'")
    zip_entry.close()

    return rgb
