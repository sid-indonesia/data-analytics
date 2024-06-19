import matplotlib.pyplot as plt

from reader import samples_reader

filename = r"./P3wtrdSq6hFxobBcXhzH.zip"


CENTRAL_PIXEL = 2
PIXEL_MAX_VALUE = 255
(RED, GREEN, BLUE) = (0, 1, 2)

samples = samples_reader.read_file(filename)

fig, ax = plt.subplots(figsize=(10, 6))
ax.plot(samples.timestamps, samples.pixels[:, CENTRAL_PIXEL, CENTRAL_PIXEL, GREEN])
ax.axvline(samples.recording_start, c="r")
ax.text(samples.recording_start, 0, "Recording starts", c="r", va="baseline")
ax.set_xlabel("Time ($s$)")
ax.set_ylabel("PPG values")
ax.set_title(f"PPG signal samples at {samples.fs:.2f} Hz")

sample_index = 210
fig, ax = plt.subplots(figsize=(10, 6))
ax.imshow(samples.pixels[sample_index, ...] / PIXEL_MAX_VALUE)
ax.set_title(f"Camera image at sample {sample_index / samples.fs:.1f}s")
plt.show()
