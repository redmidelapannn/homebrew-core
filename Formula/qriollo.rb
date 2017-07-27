class Qriollo < Formula
  desc "Impure functional language, based on Rioplatense Spanish."
  homepage "https://qriollo.github.io"
  url "https://qriollo.github.io/Qriollo-0.91.tar.gz"
  sha256 "c8357af8254a082d8e4da1de1bbf13bee27cfde8adb31ea0a5a0966bfbb7b28d"
  revision 1
  head "https://github.com/qriollo/qriollo.git"

  bottle do
    sha256 "8bd4ac99cf809efdc8e46725947411589dc67abaebe8219c84a292f46750644d" => :sierra
    sha256 "30b7e9da35b36b55ba6b0504c3e31153e058889218a9ba60dabe965857b64d58" => :el_capitan
    sha256 "feaf060a7810f243af346ebbe0a95c054169d93a0b564384ce467c67903a503d" => :yosemite
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
