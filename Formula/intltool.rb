class Intltool < Formula
  desc "String tool"
  homepage "https://wiki.freedesktop.org/www/Software/intltool"
  url "https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz"
  sha256 "67c74d94196b153b774ab9f89b2fa6c6ba79352407037c8c14d5aeb334e959cd"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "b85856eb8521ff762da915b46e5510b465ae74e43439f437e5b7863a9a10ace2" => :mojave
    sha256 "22edbf3613cb7e69b65f0accb23663ec83b2881a293bf82c504a4b8bc4a7a293" => :high_sierra
    sha256 "22edbf3613cb7e69b65f0accb23663ec83b2881a293bf82c504a4b8bc4a7a293" => :sierra
  end

  def install
    # give explicit path to brew'd xgettext as it is a GNU gettext creation
    inreplace "intltool-update.in", "|| \"xgettext\"", "|| \"#{Formula["gettext"].opt_bin}/xgettext\""
    system "./configure", "--prefix=#{prefix}",
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"intltool-extract", "--help"
  end
end
