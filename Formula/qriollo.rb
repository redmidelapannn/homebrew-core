class Qriollo < Formula
  desc "Impure functional language, based on Rioplatense Spanish"
  homepage "https://qriollo.github.io"
  url "https://qriollo.github.io/Qriollo-0.91.tar.gz"
  sha256 "c8357af8254a082d8e4da1de1bbf13bee27cfde8adb31ea0a5a0966bfbb7b28d"
  head "https://github.com/qriollo/qriollo.git"

  bottle do
    rebuild 1
    sha256 "ca05e01b144aa79137f2676746c4e6c7999c9c669c4f03482ab7cf64374736b4" => :high_sierra
    sha256 "cc6928508a3295a1a6e7075f659063208cb46d208902277311263e9516c217d5" => :sierra
    sha256 "b61e1159822ba1a798f21728d0e6a8df7b627c8f843b9f196ae8e532ddc10281" => :el_capitan
  end

  depends_on "ghc" => :build

  def install
    system "make"
    bin.install "qr"
    (lib/"chamuyo").install "Chamuyo.q"
  end

  def caveats
    <<~EOS
      The standard module "Chamuyo.q" has been placed in:
        #{lib}/chamuyo
    EOS
  end

  test do
    test_file_name = "HolaMundo.q"
    (testpath/test_file_name).write <<~EOS
      enchufar Chamuyo
      el programa es
         escupir "Hola mundo\n"
    EOS
    system bin/"qr", "--ruta", "#{lib/"chamuyo"}:#{testpath}", test_file_name
  end
end
