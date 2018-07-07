class Squashfuse < Formula
  desc "FUSE filesystem to mount squashfs archives"
  homepage "https://github.com/vasi/squashfuse"
  url "https://github.com/vasi/squashfuse/releases/download/0.1.103/squashfuse-0.1.103.tar.gz"
  sha256 "42d4dfd17ed186745117cfd427023eb81effff3832bab09067823492b6b982e7"

  depends_on "pkg-config" => :build

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

    system "./configure", *configure_args
    system "make", "install"
  end

  # Unfortunately, making/testing a squash mount requires sudo priviledges, so
  # just test that squashfuse execs for now.
  test do
    begin
      pid = fork { exec "squashfuse", "--help" }
      _, status = Process.wait2 pid

      # Returns 254 after running --help.
      assert_equal 254, status.exitstatus
    ensure
      begin
        Process.kill "TERM", pid

      # The process already exited.
      rescue Errno::ESRCH
      end 
    end
  end
end
