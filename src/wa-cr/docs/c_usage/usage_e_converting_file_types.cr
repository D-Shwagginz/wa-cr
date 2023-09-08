module Documentation
  module C_Usage
    # ### `WAD::Sound` to .wav
    #
    # To convert a `WAD::Sound` to a [WAV](https://en.wikipedia.org/wiki/WAV),
    # use `WAD::Sound#to_wav(file : String | Path | IO)`:
    #
    # ```
    # my_sound.to_wav("Path/To/MySound.wav")
    # ```
    #
    # ### .wav to `WAD::Sound`
    #
    # To convert a [WAV](https://en.wikipedia.org/wiki/WAV) to a `WAD::Sound`,
    # use `WAD::Sound.from_wav(file : String | Path | IO)`:
    #
    # ```
    # my_wav_sound = WAD::Sound.from_wav("Path/To/Sound.wav")
    # ```
    module E_ConvertingFileTypes
    end
  end
end
