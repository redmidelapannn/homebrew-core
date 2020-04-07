class Odin < Formula
  desc "The Odin Programming Language"
  homepage "https://odin-lang.org/"
  url "https://github.com/odin-lang/Odin/archive/v0.12.0.tar.gz"
  sha256 "8356124c8cc7e08ac39872e5bb10593a412e67f81df621124097facd9b2b26cc"
  head "https://github.com/odin-lang/Odin.git"

  bottle do
    cellar :any
    sha256 "abf9b5e66a983202da8ce608e43125150046c2583ee7e9e844877c37a4d1ab70" => :catalina
    sha256 "f8f375edcd8dbbe289c248252101843dee2d447e4ae54b6a81c59a81fb835fd2" => :mojave
    sha256 "7e39993ce67962ab504a94b8b271d374e98c9c0d16002db6de243ac476a47179" => :high_sierra
  end

  depends_on "llvm"

  uses_from_macos "iconv"

  def install
    system "make", "release"
    libexec.install "odin", "core", "shared"
    (bin/"odin").write <<~EOS
      #!/bin/sh
      export PATH="#{Formula["llvm"].opt_bin}:$PATH"
      #{libexec}/odin "$@"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/odin version")

    (testpath/"hellope.odin").write <<~EOS
      package main

      import "core:fmt"

      main :: proc() {
        fmt.println("Hellope!");
      }
    EOS
    system "#{bin}/odin", "build", "hellope.odin"
    assert_equal "Hellope!\n", `./hellope`
  end
end
