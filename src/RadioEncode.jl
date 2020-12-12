using WAV

module RadioEncode
    export morse_encode, morse_interactive

    morsealphabet = Dict(
        'A' => ".-",
        'B' => "-...",
        'C' => "-.-.",
        'D' => "-..",
        'E' => ".",
        'F' => "..-.",
        'G' => "--.",
        'H' => "....",
        'I' => "..",
        'J' => ".---",
        'K' => "-.-",
        'L' => ".-..",
        'M' => "--",
        'N' => "-.",
        'O' => "---",
        'P' => ".--.",
        'Q' => "--.-",
        'R' => ".-.",
        'S' => "...",
        'T' => "-",
        'V' => "...-",
        'W' => ".--",
        'X' => "-..-",
        'Y' => "-.--",
        'Z' => "--..",
        ' ' => "/",
        '1' => ".----",
        '2' => "..---",
        '3' => "...--",
        '4' => "....-",
        '5' => ".....",
        '6' => "-....",
        '7' => "--...",
        '8' => "---..",
        '9' => "----.",
        '0' => "-----",
        '.' => ".-.-.-",
        ',' => "--..--",
        '?' => "..--..",
        '\'' => ".----.",
        '-' => "-....-",
        '/' => "-..-.",
        '@' => ".--.-.",
    )




    function morse_encode(text::String, wps::Int, Fs::Int, frequency::Int)
        dotlength = 1.2 / wps

        spaceduration = Dict(" " => dotlength * 3, "/" => dotlength * 7)

        wave = sin.(2 * pi * range(0, length = Int(dotlength * Fs)) * frequency / Fs)

        wavelong = repeat(wave, 3)

        textencoded = map(x -> get(morsealphabet, x, nothing) * " ", collect(uppercase(text)))

        resultwave::Vector{Float32} = []
        for char in join(textencoded, "")
            if char == '.'
                append!(resultwave, wave)
            elseif char == '-'
                append!(resultwave, wavelong)
            end
            duration = char in keys(spaceduration) ? spaceduration[char] : dotlength

            append!(resultwave, zeros(Int(round(duration * Fs))))
        end
        return resultwave
    end

    function morse_interactive()
        println("Text: ")
        text = strip(readline())

        print("WPS: ")
        wps = parse(Int, strip(readline()))

        print("Sample Rate: ")
        Fs = parse(Int, strip(readline()))

        print("Frequency: ")
        frequency = parse(Int, strip(readline()))

        wavwrite(encode(text, wps, Fs, frequency), "output.wav", Fs = Fs)
    end
end
