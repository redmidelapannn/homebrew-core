class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2019-12-24T23-41-36Z",
      :revision => "7c9ea887427db85719b3d2c456b40e96b23230a6"
  version "20191224234136"

  bottle do
    cellar :any_skip_relocation
    sha256 "9d86d851b0ce7d1c6ce3d2983561967ddf7a654a5fb26a0d80402138007a6bb3" => :catalina
    sha256 "04b8f7754de5a2044dbacf9b780c8f98845bc3752d845346d364c9231ef1033f" => :mojave
    sha256 "7e4d111eadf09a4b0be8f5e97261894b1e5a5f519339585fd11ce221f06bf6d3" => :high_sierra
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", :because => "Both install a `mc` binary"

  def install
    if build.head?
      system "go", "build", "-trimpath", "-o", bin/"mc"
    else
      minio_release = `git tag --points-at HEAD`.chomp
      minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)\-(\d+)\-(\d+)Z/, 'T\1:\2:\3Z')
      minio_commit = `git rev-parse HEAD`.chomp
      proj = "github.com/minio/mc"

      system "go", "build", "-trimpath", "-o", bin/"mc", "-ldflags", <<~EOS
        -X #{proj}/cmd.Version=#{minio_version}
        -X #{proj}/cmd.ReleaseTag=#{minio_release}
        -X #{proj}/cmd.CommitID=#{minio_commit}
      EOS
    end

    prefix.install_metafiles
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
