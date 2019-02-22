class Netdata < Formula
  desc "Distributed real-time performance and health monitoring"
  homepage "https://my-netdata.io/"
  url "https://github.com/netdata/netdata/releases/download/v1.12.1/netdata-v1.12.1.tar.gz"
  sha256 "ce4516af03a6dc17a1219e939eb6b4c14ec44fd73d186797c9390260c4cfe571"

  bottle do
    sha256 "58f68205aba699598fbf985bcc7092b0e349283648154d510b0be0bf20125abf" => :mojave
    sha256 "4b40892ddab5ff3ce3d876af6d8f106f359a559b8e48ef60b12d3e2c1bd77aa9" => :high_sierra
    sha256 "60fb0dbdd7f0d71bb19d8150e65fd51e66108dbe2b9b8e3bc6d04e72acb751fa" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "ossp-uuid"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"

    (etc/"netdata").install "system/netdata.conf"
  end

  def post_install
    config = etc/"netdata/netdata.conf"
    inreplace config do |s|
      s.gsub!(/web files owner = .*/, "web files owner = #{ENV["USER"]}")
      s.gsub!(/web files group = .*/, "web files group = #{Etc.getgrgid(prefix.stat.gid).name}")
    end
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/sbin/netdata -D"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_sbin}/netdata</string>
            <string>-D</string>
        </array>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
      </dict>
    </plist>
  EOS
  end

  test do
    system "#{sbin}/netdata", "-W", "set", "registry", "netdata unique id file",
                              "#{testpath}/netdata.unittest.unique.id",
                              "-W", "unittest"
  end
end
