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

  # Compression algorithms supported by squashfuse
  depends_on "lz4"
  depends_on "lzo"
  depends_on :osxfuse
  depends_on "squashfs"
  depends_on "xz"
  depends_on "zstd"

  def install
    configure_args = [
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
    ]

    %w[lz4 lz0 xz zlib zstd].each do |algorithm|
      configure_args << "--with-#{algorithm}=#{HOMEBREW_PREFIX}"
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
