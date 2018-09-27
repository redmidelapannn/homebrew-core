class SpawnFcgi < Formula
  desc "Spawn fast-CGI processes"
  homepage "https://redmine.lighttpd.net/projects/spawn-fcgi"
  url "https://www.lighttpd.net/download/spawn-fcgi-1.6.4.tar.gz"
  sha256 "ab327462cb99894a3699f874425a421d934f957cb24221f00bb888108d9dd09e"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "202224c58c18c77a6cda192b1013c6a14c0fe72b0d5973475f28dd7921ce82e5" => :mojave
    sha256 "9f314245460ebece0f42dd563161f3a5ac5078b6ab6dc8fe08aafc2be330554f" => :high_sierra
    sha256 "24c191555f9882087ed8fdad4fd3da2430612a885ab4f5a8c1f8d94d5ad6f7cb" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/spawn-fcgi", "--version"
  end
end
