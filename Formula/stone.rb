class Stone < Formula
  desc "TCP/IP packet repeater in the application layer"
  homepage "https://www.gcd.org/sengoku/stone/"
  url "https://www.gcd.org/sengoku/stone/stone-2.3e.tar.gz"
  sha256 "b2b664ee6771847672e078e7870e56b886be70d9ff3d7b20d0b3d26ee950c670"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "33ae8f6669b7d6be60b7a9edc1ab55fd2c53596049da8d2fd22639cf85ccae7a" => :mojave
    sha256 "762df31c6adb07040684ae5cc4888fc0e140401322477d33ce57075434b0f27a" => :high_sierra
    sha256 "6c163eb9b969b9e050166c3f0f7f8fd6433cc6cc09bdcee35e982aeff535cc00" => :sierra
  end

  def install
    system "make", "macosx"
    bin.install "stone"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/stone -h 2>&1", 1)
  end
end
