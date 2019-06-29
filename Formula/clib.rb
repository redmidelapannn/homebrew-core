class Clib < Formula
  desc "Package manager for C programming"
  homepage "https://github.com/clibs/clib"
  url "https://github.com/clibs/clib/archive/1.8.1.tar.gz"
  sha256 "f5718e316771571971cb4e5a0142f91b47c6bfe32997fd869fc5a90ec091a066"
  head "https://github.com/clibs/clib.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e1f7dc265ede21149843994bb248cf84ce5563164436688c1f5f050a62cf7396" => :mojave
    sha256 "94d522a42f590ca7e3c9d24d5f377a4187baa64d27ee96879c093ea6ab17fd15" => :high_sierra
    sha256 "d6ff72f850f5b2667d5da203cd718c698c0346c0b6143b32eed64c0f55ee6a9b" => :sierra
  end

  uses_from_macos "curl"

  def install
    ENV["PREFIX"] = prefix
    system "make", "install"
  end

  test do
    system "#{bin}/clib", "install", "stephenmathieson/rot13.c"
  end
end
