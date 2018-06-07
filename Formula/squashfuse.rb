class Squashfuse < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://github.com/vasi/squashfuse/archive/0.1.103.tar.gz"
  sha256 "bba530fe435d8f9195a32c295147677c58b060e2c63d2d4204ed8a6c9621d0dd"

  # Build deps
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  # Hard dependency for OSX FUSE
  depends_on :osxfuse

  # Makes sense to have this
  depends_on "squashfs" => :recommended

  # Possible compression algorithms to build with
  depends_on "lz4" => :optional
  depends_on "lzo" => :optional
  depends_on "xz" => :optional
  depends_on "zstd" => :optional

  def install
    configure_args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]

    %w[lz4 xz lzo zstd].each do |algorithm|
      if build.with? algorithm
        configure_args << "--with-#{algorithm}=#{HOMEBREW_PREFIX}"
      end
    end
    system "./autogen.sh"
    system "./configure", *configure_args
    system "make", "install"
  end

  # Unfortunately, making/testing a squash mount requires sudo priviledges, so
  # just test that squashfuse execs for now.
  test do
    pid = fork { exec "squashfuse", "--help" }
    _, status = Process.wait2 pid

    # Returns 254 after running --help.
    assert_equal 254, status.exitstatus
  end
end
