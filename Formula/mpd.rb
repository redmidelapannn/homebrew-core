class Mpd < Formula
  desc "Music Player Daemon"
  homepage "https://www.musicpd.org/"
  revision 1

  stable do
    url "https://www.musicpd.org/download/mpd/0.20/mpd-0.20.18.tar.xz"
    sha256 "6a582dc2ae90b94ff3853f9ffd7d80b2c2b5fe2e2c35cb1da0b36f3f3dfad434"

    # Remove for > 0.20.18
    # Fix missing user-provided default constructor with old clang
    # Upstream commit from 24 Feb 2018 "net/Init: work around -Werror=unused-variable"
    if MacOS.version <= :el_capitan
      patch do
        url "https://github.com/MusicPlayerDaemon/MPD/commit/418f71ec0.patch?full_index=1"
        sha256 "c059916176841f52d0f5a377b7c6dd19d012dc833a83fad55d4b2b31d41a6c8f"
      end
    end
  end

  bottle do
    rebuild 1
    sha256 "d0dac4d2fff3371c4fe9ae3ed2d72b957a74e6156a7405e39dd56e6b434147e4" => :high_sierra
    sha256 "b6a35f24263455c91d1007729bde1b5edcb2f1d4e43e23b5ebe17f94f69af9e7" => :sierra
    sha256 "a2c5fa83b41e104d626e1d60d0bc530bc851d090261e292af323709aed081dd5" => :el_capitan
  end

  head do
    url "https://github.com/MusicPlayerDaemon/MPD.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  option "with-wavpack", "Build with wavpack support (for .wv files)"
  option "with-lastfm", "Build with last-fm support (for experimental Last.fm radio)"
  option "with-lame", "Build with lame support (for MP3 encoding when streaming)"
  option "with-two-lame", "Build with two-lame support (for MP2 encoding when streaming)"
  option "with-flac", "Build with flac support (for Flac encoding when streaming)"
  option "with-libvorbis", "Build with vorbis support (for Ogg encoding)"
  option "with-yajl", "Build with yajl support (for playing from soundcloud)"
  option "with-opus", "Build with opus support (for Opus encoding and decoding)"
  option "with-libmodplug", "Build with modplug support (for decoding modules supported by MODPlug)"
  option "with-pulseaudio", "Build with PulseAudio support (for sending audio output to a PulseAudio sound server)"
  option "with-upnp", "Build with upnp database plugin support"

  deprecated_option "with-vorbis" => "with-libvorbis"

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "glib"
  depends_on "libid3tag"
  depends_on "sqlite"
  depends_on "libsamplerate"
  depends_on "icu4c"

  needs :cxx11

  depends_on "libmpdclient"
  depends_on "ffmpeg" # lots of codecs
  # mpd also supports mad, mpg123, libsndfile, and audiofile, but those are
  # redundant with ffmpeg
  depends_on "fluid-synth"              # MIDI
  depends_on "faad2"                    # MP4/AAC
  depends_on "wavpack" => :optional     # WavPack
  depends_on "libshout" => :optional    # Streaming (also pulls in Vorbis encoding)
  depends_on "lame" => :optional        # MP3 encoding
  depends_on "two-lame" => :optional    # MP2 encoding
  depends_on "flac" => :optional        # Flac encoding
  depends_on "jack" => :optional        # Output to JACK
  depends_on "libmms" => :optional      # MMS input
  depends_on "libzzip" => :optional     # Reading from within ZIPs
  depends_on "yajl" => :optional        # JSON library for SoundCloud
  depends_on "opus" => :optional        # Opus support
  depends_on "libvorbis" => :optional
  depends_on "libnfs" => :optional
  depends_on "mad" => :optional
  depends_on "libmodplug" => :optional  # MODPlug decoder
  depends_on "pulseaudio" => :optional
  depends_on "libao" => :optional       # Output to libao
  if build.with? "upnp"
    depends_on "expat"
    depends_on "libupnp"
  end

  # Fixes "error: no member named 'next' in namespace 'boost'"
  # Upstream PR from 18 Apr 2018 "Fix build with Boost 1.67.0"
  patch do
    url "https://github.com/MusicPlayerDaemon/MPD/pull/266.patch?full_index=1"
    sha256 "4893fb76f4ca8e8e0fae6a84a042039920c828966df4df026e344d5f5a6f14ac"
  end

  def install
    # mpd specifies -std=gnu++0x, but clang appears to try to build
    # that against libstdc++ anyway, which won't work.
    # The build is fine with G++.
    ENV.libcxx

    system "./autogen.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --enable-bzip2
      --enable-ffmpeg
      --enable-fluidsynth
      --enable-osx
      --disable-libwrap
    ]

    args << "--disable-mad" if build.without? "mad"
    args << "--enable-zzip" if build.with? "libzzip"
    args << "--enable-lastfm" if build.with? "lastfm"
    args << "--disable-lame-encoder" if build.without? "lame"
    args << "--disable-soundcloud" if build.without? "yajl"
    args << "--enable-vorbis-encoder" if build.with? "libvorbis"
    args << "--enable-nfs" if build.with? "libnfs"
    args << "--enable-modplug" if build.with? "libmodplug"
    args << "--enable-pulse" if build.with? "pulseaudio"
    args << "--enable-ao" if build.with? "libao"
    if build.with? "upnp"
      args << "--enable-upnp"
      args << "--enable-expat"
    end

    system "./configure", *args
    system "make"
    ENV.deparallelize # Directories are created in parallel, so let's not do that
    system "make", "install"

    (etc/"mpd").install "doc/mpdconf.example" => "mpd.conf"
  end

  plist_options :manual => "mpd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/mpd</string>
            <string>--no-daemon</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>ProcessType</key>
        <string>Interactive</string>
    </dict>
    </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/mpd --stdout --no-daemon --no-config"
    end
    sleep 2

    begin
      assert_match "OK MPD", shell_output("curl localhost:6600")
      assert_match "ACK", shell_output("(sleep 2; echo playid foo) | nc localhost 6600")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
