class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://www.mirbsd.org/mksh.htm"
  url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R57.tgz"
  sha256 "3d101154182d52ae54ef26e1360c95bc89c929d28859d378cc1c84f3439dbe75"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ce5b21dde43d7060f392d43de970042a9636d7072bfd76fd3ed432d9205bd977" => :mojave
    sha256 "5efdaf2d1992ff7cb3d987129c057b3a7a13853edfb62f89c916b1680a0fc396" => :high_sierra
    sha256 "ec1b776bc87892435f1ce61a9bcf253a1a0995f5a177a123af5d36384fd54e0c" => :sierra
  end

  def install
    system "sh", "./Build.sh", "-r", "-c", (ENV.compiler == :clang) ? "lto" : "combine"
    bin.install "mksh"
    man1.install "mksh.1"
  end

  test do
    assert_equal "honk",
      shell_output("#{bin}/mksh -c 'echo honk'").chomp
  end
end
