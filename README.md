# llama2.c-android

<img src="assets/llama_android.png" width="300" height="300">

Port of Andrej Karpathy's [llama2.c](https://github.com/karpathy/llama2.c) to Android. You can run it as raw binary or use it as shared library.

You can use the prebuild binaries in `libs` or compile on your own:

```bash
# or wherever your ndk-build script resides
cd jni && $ANDROID_HOME/ndk-bundle/ndk-build
```

## run as binary

Get e.g. [termux](https://f-droid.org/en/packages/com.termux/) and install APK to run binaries.

```bash
wget https://karpathy.ai/llama2c/model.bin -P out
adb push libs/<your abi>/llama2 /storage/emulated/0/Android/data
adb push model.bin /storage/emulated/0/Android/data
adb push tokenizer.bin /storage/emulated/0/Android/data
```

In Termux:

```bash 
cp /storage/emulated/0/Android/llama2 .
chmod +x llama2
./llama2 model.bin
```

[Llama2 in Termux](assets/llama2_in_termux.webm)

## run as shared lib

wip

