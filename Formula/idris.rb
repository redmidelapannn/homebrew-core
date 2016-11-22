require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.12.3.tar.gz"
  sha256 "c6f410cddddbc53c4779d3612be40ef4e4f1f11ce8083a811825763daf30ee4d"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "a69b23764bb5f9a78f4fbd1791f939e86407d8ed2d01e01aabf5c6dc835feccf" => :sierra
    sha256 "33a358eb043be6aa3ff9ca76e060f13281d72e8777874fbd22a1625fc8ccb84a" => :el_capitan
    sha256 "304ea6fef86027134d9ae75c6563a9fb28812af60d05d04d68e0ecffd140bd6f" => :yosemite
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pkg-config" => :build

  depends_on "gmp"
  depends_on "libffi" => :recommended

  # Remove once trifecta > 1.6 is released to Hackage
  # Fix "Couldn't match type 'Parser' with 'IdrisInnerParser' ..."
  # Upstream commit from 27 Oct 2016 "Remove redundant constraint in DeltaParsing method"
  # See http://git.haskell.org/ghc.git/blob/HEAD:/docs/users_guide/8.0.2-notes.rst#l32
  resource "trifecta-patch" do
    url "https://github.com/ekmett/trifecta/commit/aaa47fa.patch"
    sha256 "eb5d36506461d6caae38b27ca7d9045d69efb3dea3fe718b44ee97a719feca1c"
  end

  def install
    args = []
    args << "-f FFI" if build.with? "libffi"
    args << "-f release" if build.stable?

    cabal_sandbox do
      system "cabal", "get", "trifecta"
      resource("trifecta-patch").stage do
        system "patch", "-p1", "-i", Pathname.pwd/"aaa47fa.patch", "-d",
                        buildpath/"trifecta-1.6"
      end
      cabal_sandbox_add_source "trifecta-1.6"
      install_cabal_package *args
    end
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
