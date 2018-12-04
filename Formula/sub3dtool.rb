class Sub3dtool < Formula
  desc "Sub3dtool"
  homepage "https://code.google.com/archive/p/sub3dtool/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/sub3dtool/sub3dtool-0.4.2.tar.gz"
  sha256 "afb8ed7456a0b17035d27865343dbc9687a178e2ecf4362a7c0dd1b00dccf155"
  bottle do
    cellar :any_skip_relocation
    sha256 "10f6dbe6ff79a689d7fee230a5dd38cff8ede6b267945dd7d585bc591fbf4640" => :mojave
    sha256 "35651b9f97ddbbf8c5a3a79ef1fbf42eb8df40307b06d5d611bc7f55ee021210" => :high_sierra
    sha256 "a2db13a7e312aaefd9542c01235c77d74e46c53e8ad61d547421ce7f4d9e4c61" => :sierra
  end

  depends_on "make" => :build

  def install
    system "make"
    bin.install "sub3dtool"
  end

  test do
    system "#{bin}/sub3dtool", "--help"
  end
end
