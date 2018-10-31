class Zssh < Formula
  desc "Interactive file transfers over SSH"
  homepage "https://zssh.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/zssh/zssh/1.5/zssh-1.5c.tgz"
  sha256 "a2e840f82590690d27ea1ea1141af509ee34681fede897e58ae8d354701ce71b"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4058542dd46ccafcb7175337c14120266cd783a24bb7f92bb5a6ab49dc907441" => :mojave
    sha256 "b3078ec5ca52ba03c59ed1674c9df7a7890ede0ac80eb92d9fdcb8d143966bc9" => :high_sierra
    sha256 "5215ab6aaf222aa357f0b3361e23265dcf06059e2dd9f0fc8e100b91ca12577b" => :sierra
  end

  depends_on "lrzsz"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"

    bin.install "zssh", "ztelnet"
    man1.install "zssh.1", "ztelnet.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zssh --version 2>&1")
  end
end
