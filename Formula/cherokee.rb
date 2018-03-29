class Cherokee < Formula
  desc "Modern, user friendly web server"
  homepage "http://cherokee-project.com/"
  url "https://src.fedoraproject.org/repo/pkgs/cherokee/cherokee-1.2.103.tar.gz/527b3de97ef9727bfd5f6832043cf916/cherokee-1.2.103.tar.gz"
  sha256 "790777e7b4355b60698443161e45b5a20a9d0ab8c4c47924e00d19da8b74dfcd"

  bottle do
    rebuild 1
    sha256 "8350480ff8516eb1d51ca74948e92e3e937869c7c8b299e65faa56f7367ad724" => :high_sierra
    sha256 "fcc9e4016c5920e06ee0c4314ca39608054a586249947e232f2b467b5ee1ca28" => :sierra
    sha256 "9b782f75dd655bd49aa2a71bee739897b1dbdcefcf495851e5226706c10de12e" => :el_capitan
  end

  depends_on "gettext"
  depends_on "openssl"

  # OS X 10.9 patch
  patch do
    url "https://github.com/cherokee/webserver/commit/d0213768fdc6cf3aee61fe0be398d7825c01198f.diff?full_index=1"
    sha256 "dc4c678e55b906a5a1437f93789232a6eb016e80214e92b0032f50c68ae2997b"
  end

  def install
    if build.head?
      ENV["LIBTOOL"] = "glibtool"
      ENV["LIBTOOLIZE"] = "glibtoolize"
      cmd = "./autogen.sh"
    else
      cmd = "./configure"
    end

    system cmd, "--disable-dependency-tracking",
                "--prefix=#{prefix}",
                "--sysconfdir=#{etc}",
                "--localstatedir=#{var}/cherokee",
                "--with-wwwuser=#{ENV["USER"]}",
                "--with-wwwgroup=www",
                "--enable-internal-pcre",
                # Don't install to /Library
                "--with-wwwroot=#{etc}/cherokee/htdocs",
                "--with-cgiroot=#{etc}/cherokee/cgi-bin"
    system "make", "install"

    prefix.install "org.cherokee.webserver.plist"
    (prefix+"org.cherokee.webserver.plist").chmod 0644
    (pkgshare/"admin/server.py").chmod 0755
  end

  def caveats
    <<~EOS
      Cherokee is setup to run with your user permissions as part of the
      www group on port 80. This can be changed in the cherokee-admin
      but be aware the new user will need permissions to write to:
        #{var}/cherokee
      for logging and runtime files.

      By default, documents will be served out of:
        #{etc}/cherokee/htdocs

      And CGI scripts from:
        #{etc}/cherokee/cgi-bin

       If this is your first install, automatically load on startup with:
          sudo cp #{prefix}/org.cherokee.webserver.plist /Library/LaunchDaemons
          sudo launchctl load -w /Library/LaunchDaemons/org.cherokee.webserver.plist

      If this is an upgrade and you already have the plist loaded:
          sudo launchctl unload -w /Library/LaunchDaemons/org.cherokee.webserver.plist
          sudo cp #{prefix}/org.cherokee.webserver.plist /Library/LaunchDaemons
          sudo launchctl load -w /Library/LaunchDaemons/org.cherokee.webserver.plist
    EOS
  end

  test do
    assert_match "Version: #{version}", shell_output("#{sbin}/cherokee -i")
  end
end
