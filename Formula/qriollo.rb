class Qriollo < Formula
  desc "Impure functional language, based on Rioplatense Spanish"
  homepage "https://qriollo.github.io"
  url "https://qriollo.github.io/Qriollo-0.91.tar.gz"
  sha256 "c8357af8254a082d8e4da1de1bbf13bee27cfde8adb31ea0a5a0966bfbb7b28d"
  head "https://github.com/qriollo/qriollo.git"

  bottle do
    rebuild 1
    sha256 "e392b65d98c93638a1cbb666ce9932b7b07b4ab57481b4b6a4f8d53cfd0d8048" => :high_sierra
    sha256 "ba9f8afc4aa4ffd4c3848864c1bc2c554deae2c0291728ce2a9a01fa51a628de" => :sierra
    sha256 "4772b1b1d259dead337666032ba5cead407c386a25925f028c902c10259cebfe" => :el_capitan
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
