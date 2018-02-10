class BaculaFd < Formula
  desc "Network backup solution"
  homepage "https://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/9.0.6/bacula-9.0.6.tar.gz"
  sha256 "44db9d12dd4a510b0dfa6f8ad877ad4c0df04c13ef28f99c690a259314ee2e47"

  bottle do
    rebuild 1
    sha256 "cfaddfac121e88ea889649343d7ffb76a5d01404c0b75ae2dc330482253b5ddb" => :high_sierra
    sha256 "b765f6e60dace9cff67939234ae08fe2d182bb509317a2568c838a58bfb435c4" => :sierra
    sha256 "33117ee5a376b08fb7c849ae2550a77743a50a6bb351f0989832915fb155485c" => :el_capitan
  end

  depends_on "readline"
  depends_on "openssl"

  conflicts_with "bareos-client",
    :because => "Both install a `bconsole` executable."

  def install
    # * sets --disable-conio in order to force the use of readline
    #   (conio support not tested)
    # * working directory in /var/lib/bacula, reasonable place that
    #   matches Debian's location.
    system "./configure", "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--with-working-dir=#{var}/lib/bacula",
                          "--with-pid-dir=#{var}/run",
                          "--with-logdir=#{var}/log/bacula",
                          "--enable-client-only",
                          "--disable-conio",
                          "--with-readline=#{Formula["readline"].opt_prefix}"

    system "make"
    system "make", "install"

    (var/"lib/bacula").mkpath
  end

  def post_install
    (var/"run").mkpath
  end

  plist_options :startup => true, :manual => "bacula-fd"

  def plist; <<~EOS
    <?xml version="0.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/bacula-fd</string>
          <string>-f</string>
        </array>
      </dict>
    </plist>
  EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bacula-fd -? 2>&1", 1)
  end
end
