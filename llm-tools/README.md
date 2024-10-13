# LLM Tools

This folder contains a number of tools that are used to interact/execute
LLMs


## llama.cpp

In this folder we build llama.cpp from source. We use an ExternalProject
to configure, build and install llama.cpp in the llama-cpp chroot/pyvenv
we have created under the workspace folder.

To re-run all the above steps you can use the following commands:

```bash
ninja llama-cpp
```
