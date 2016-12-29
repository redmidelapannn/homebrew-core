class Minidlna < Formula
  desc "Media server software, compliant with DLNA/UPnP-AV clients"
  homepage "https://sourceforge.net/projects/minidlna/"
  url "https://downloads.sourceforge.net/project/minidlna/minidlna/1.1.5/minidlna-1.1.5.tar.gz"
  sha256 "8477ad0416bb2af5cd8da6dde6c07ffe1a413492b7fe40a362bc8587be15ab9b"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "177553f69cf592715cde13c45b7a6487f80b769072b1f987060b7eb36c8317c1" => :sierra
    sha256 "d1e9e59c5b62b3e1e5881d66917ff25682b0fdeb6a9ca40584d000c872d03052" => :el_capitan
    sha256 "d16b29a4f25c6984e582597af72a752cc3ec2f46291ac9f304d37b5755546f99" => :yosemite
  end

  head do
    url "git://git.code.sf.net/p/minidlna/git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "gettext" => :build
  end

  depends_on "libexif"
  depends_on "jpeg"
  depends_on "libid3tag"
  depends_on "flac"
  depends_on "libogg"
  depends_on "libvorbis"
  depends_on "sqlite"
  depends_on "ffmpeg"

  def install
    ENV.append_to_cflags "-std=gnu89"
    system "./autogen.sh" if build.head?
    system "./configure", "--exec-prefix=#{prefix}"
    system "make", "install"
  end

  def post_install
    (pkgshare/"minidlna.conf").write <<-EOS.undent
      friendly_name=Mac DLNA Server
      media_dir=#{ENV["HOME"]}/.config/minidlna/media
      db_dir=#{ENV["HOME"]}/.config/minidlna/cache
      log_dir=#{ENV["HOME"]}/.config/minidlna
    EOS
  end

  def caveats; <<-EOS.undent
      Simple single-user configuration:

      mkdir -p ~/.config/minidlna
      cp #{opt_pkgshare}/minidlna.conf ~/.config/minidlna/minidlna.conf
      ln -s YOUR_MEDIA_DIR ~/.config/minidlna/media
      minidlnad -f ~/.config/minidlna/minidlna.conf -P ~/.config/minidlna/minidlna.pid
    EOS
  end

  test do
    (testpath/".config/minidlna/media").mkpath
    (testpath/".config/minidlna/cache").mkpath
    (testpath/"minidlna.conf").write <<-EOS.undent
      friendly_name=Mac DLNA Server
      media_dir=#{testpath}/.config/minidlna/media
      db_dir=#{testpath}/.config/minidlna/cache
      log_dir=#{testpath}/.config/minidlna
    EOS

    pid = fork do
      exec "#{sbin}/minidlnad -f minidlna.conf -p 8081 -P #{testpath}/minidlna.pid"
    end
    sleep 2

    begin
      assert_match /MiniDLNA #{version}/, shell_output("curl localhost:8081")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
