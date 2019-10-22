class Vavrdiasm < Formula
  desc "8-bit Atmel AVR disassembler"
  homepage "https://github.com/vsergeev/vAVRdisasm"
  url "https://github.com/vsergeev/vavrdisasm/archive/v3.1.tar.gz"
  sha256 "4fe5edde40346cb08c280bd6d0399de7a8d2afdf20fb54bf41a8abb126636360"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "d402eb421a4a73cf3acf50c883da689670d91980a2c40d723ff72b6056ed9647" => :catalina
    sha256 "08baf1a800bdda38540a0c6cf91b5f1559e392fa2a744b2d5a6531aa21910ee9" => :mojave
    sha256 "98c93813089ec5ae0ae402e59c55371caa9c9393693432875765e10d2df77842" => :high_sierra
  end

  # Patch:
  # - BSD `install(1)' does not have a GNU-compatible `-D' (create intermediate
  #   directories) flag. Switch to using `mkdir -p'.
  # - Make `PREFIX' overridable
  #   https://github.com/vsergeev/vavrdisasm/pull/2
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/vavrdiasm/3.1.patch"
    sha256 "e10f261b26e610e3f522864217b53e7b38d270b5d218a67840a683e1cdc20893"
  end

  def install
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    # Code to generate `file.hex':
    ## .device ATmega88
    ##
    ## LDI     R16, 0xfe
    ## SER     R17
    #
    # Compiled with avra:
    ## avra file.S && mv file.S.hex file.hex

    (testpath/"file.hex").write <<~EOS
      :020000020000FC
      :040000000EEF1FEFF1
      :00000001FF
    EOS

    output = `vavrdisasm file.hex`.lines.to_a

    assert output[0].match(/ldi\s+R16,\s0xfe/).length == 1
    assert output[1].match(/ser\s+R17/).length == 1
  end
end
