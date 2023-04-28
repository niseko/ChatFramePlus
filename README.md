# ChatFramePlus

ChatFramePlus is an addon for World of Warcraft: Wrath of the Lich King Classic that allows for further modification of individual chat frames.

## Quick Start

To see a list of available commands, type `/cfp` or `/chatframeplus` into the chat and hit enter.

## Performance

The goal is for ChatFramePlus to be light on memory usage. Whether I'm implementing the systems below properly to achieve that is a good question. Feel free to let me know if I'm not!

### Caching

Chat frame settings are stored in a cache for faster retrieval by eliminating the need for frequent database queries.

### Pools

Frames use Blizzard's `CreateFramePool()` function, which minimizes the creation and destruction of frames, reducing memory overhead.

### Demo

https://user-images.githubusercontent.com/79545110/235074325-2b59e46b-d42a-4711-ae4a-81d97b3bc67e.mp4
