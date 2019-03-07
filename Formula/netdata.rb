class Netdata < Formula
  desc "Distributed real-time performance and health monitoring"
  homepage "https://my-netdata.io/"
  url "https://github.com/netdata/netdata/releases/download/v1.12.2/netdata-v1.12.2.tar.gz"
  sha256 "f8cd689ec1ab262903b5a54c8df2fd0fe6e5e7b0ab4a2c60fde4e88f37aa72b5"

  bottle do
    sha256 "27f15269e669681f93bda97e793da5a12141eee4f3443177f190e9d26d856ee2" => :high_sierra
    sha256 "0df0e5c2cf96560fa5688cd9040f8fd63269765816464f864ea660f48eb1da78" => :sierra
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
