class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2020-04-02T21-50-12Z",
      :revision => "51ef254a411dea3aa703b417d6fd43a7fdd8451b"
  version "20200402215012"

  bottle do
    cellar :any_skip_relocation
    sha256 "79fbff9f6b188ee4b19b7ccde1cda7b582574a43c204fd7b998a6ebe289301d7" => :catalina
    sha256 "1995fec9b78ccd35238111318d0294047f85cc11388b4c0975c7ea8c5a31bd31" => :mojave
    sha256 "34d53c8f8d133dfc74c79c3dbed3c07330e04e1223f4befb8007f03f209710e6" => :high_sierra
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
