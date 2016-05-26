class Qriollo < Formula
  desc "Impure functional language, based on Rioplatense Spanish."
  homepage "https://qriollo.github.io"
  url "https://qriollo.github.io/Qriollo-0.91.tar.gz"
  sha256 "c8357af8254a082d8e4da1de1bbf13bee27cfde8adb31ea0a5a0966bfbb7b28d"
  revision 1
  head "https://github.com/qriollo/qriollo.git"

  bottle do
    sha256 "51b957dd4d5df7ca4b9bcc7192649f831fc4c4b94b06c17c658cc81a2a198744" => :el_capitan
    sha256 "fb3808625b89d3afa852141edaf8459afdd47006e0dc185df74e58611b8485fd" => :yosemite
    sha256 "b21c1c7a445d4b96d006e77458d8923f4f6f5afa239665e662c602404ad765ce" => :mavericks
  end

  depends_on "ghc" => :build

  def install
    system "make"
    bin.install "qr"
    (lib/"chamuyo").install "Chamuyo.q"
  end

  def caveats
    <<-EOS.undent
      The standard module "Chamuyo.q" has been placed in:
        #{lib}/chamuyo
    EOS
  end

  test do
    test_file_name = "HolaMundo.q"
    (testpath/test_file_name).write <<-EOS.undent
      enchufar Chamuyo
      el programa es
         escupir "Hola mundo\n"
    EOS
    system bin/"qr", "--ruta", "#{lib/"chamuyo"}:#{testpath}", test_file_name
  end
end
