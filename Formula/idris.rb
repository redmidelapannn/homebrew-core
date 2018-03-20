require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v1.2.0.tar.gz"
  sha256 "a5160da66cdfb376df0ed87f0abb9dbc7feaa4efe77bcc7f9cc3b97425bc57f7"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    rebuild 1
    sha256 "cca11e36b63c4d7fcdbdcef54540964e814ba7ecc6df9a1608ab26c51732d1cc" => :high_sierra
    sha256 "4a40e5bed22cb584c59713efd5a10ca59f058591838740596447c78de4fbaf38" => :sierra
    sha256 "a51338d6f330044d115fc534d93c964cfba0c4aa668f36e61187cd28f65d167b" => :el_capitan
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@8.2" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi"

  def install
    args = ["-f", "FFI"]
    args << "-f" << "release" if build.stable?
    install_cabal_package *args
  end

  test do
    (testpath/"hello.idr").write <<~EOS
      module Main
      main : IO ()
      main = putStrLn "Hello, Homebrew!"
    EOS

    system bin/"idris", "hello.idr", "-o", "hello"
    assert_equal "Hello, Homebrew!", shell_output("./hello").chomp

    if build.with? "libffi"
      (testpath/"ffi.idr").write <<~EOS
        module Main
        puts: String -> IO ()
        puts x = foreign FFI_C "puts" (String -> IO ()) x
        main : IO ()
        main = puts "Hello, interpreter!"
      EOS

      system bin/"idris", "ffi.idr", "-o", "ffi"
      assert_equal "Hello, interpreter!", shell_output("./ffi").chomp
    end
  end
end
