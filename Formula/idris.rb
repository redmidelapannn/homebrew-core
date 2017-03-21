require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "https://www.idris-lang.org/"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.99.1.tar.gz"
  sha256 "0e0ba94f1e6f7b154f5dc41fc41cc0736724a79600156558c0d04c582476b288"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    rebuild 1
    sha256 "5c5f8c294a75cca6fb92a32c3c7b056bc0d907559b1a02848d94b7e42002b1e5" => :sierra
    sha256 "c9227e01c5c1af4edb5c94f138e1d9d2af09a3c303db7b3a72d328c352036ea9" => :el_capitan
    sha256 "dd591b7bb93c6830cededbd154e80a39d378e4181c618ce0c7fa44b37bd9fcb4" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build

  depends_on "gmp"
  depends_on "libffi" => :recommended

  def install
    args = []
    args << "-f FFI" if build.with? "libffi"
    args << "-f release" if build.stable?
    install_cabal_package *args
  end

  test do
    (testpath/"hello.idr").write <<-EOS.undent
      module Main
      main : IO ()
      main = putStrLn "Hello, Homebrew!"
    EOS

    system bin/"idris", "hello.idr", "-o", "hello"
    assert_equal "Hello, Homebrew!", shell_output("./hello").chomp

    if build.with? "libffi"
      (testpath/"ffi.idr").write <<-EOS.undent
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
