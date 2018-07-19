class Xarexec < Formula
  desc "The eXecutable Archive Format"
  homepage "https://github.com/facebookincubator/xar"
  url "https://github.com/facebookincubator/xar/archive/v18.07.12.tar.gz"
  sha256 "517414281f02af5c304cb87f08c855e3e5ca812580ff94ff48972d68ec75558d"

  bottle do
    cellar :any_skip_relocation
    sha256 "0997b517e8528f076742f54541ed058c8c66bfd07034e8ee54c428fb1d63ea4a" => :high_sierra
    sha256 "2865c151fcc5b5f3d8d5f33da9e9e638be538bb68c455088f0c71a1e0144e8af" => :sierra
    sha256 "8a7c623eabb610a263b9df9fe3b34a1235aa22a1ce3b4e260130da2556b11511" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on :osxfuse
  depends_on "squashfuse"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    def pid_exists?(pid)
      Process.kill 0, pid
      true
    rescue Errno::ESRCH
      false
    end

    begin
      pid = fork { exec "#{bin}/xarexec_fuse", "--help" }
      _, status = Process.wait2 pid
      assert_equal 1, status.exitstatus
    ensure
      Process.kill "TERM", pid if pid_exists? pid
    end
  end
end
