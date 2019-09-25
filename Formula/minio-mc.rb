class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2019-09-24T01-36-20Z",
      :revision => "643835013047aa27ed35de0ac5a4ab9538f0cd68"
  version "20190924013620"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "ac22c265271a6c091e678f49d70b2b2d076aa105244ec08349f034539a6f9eb0" => :mojave
    sha256 "ba1da00e6e3967030153d4f65a90a77ed36c0cedd3f90213cddb6c87fe7aab49" => :high_sierra
    sha256 "28b90c5099cbaf0da523e920c4468c678eb3a0d467ba6be81250f4f4ea727971" => :sierra
  end

  depends_on "go" => :build

  conflicts_with "midnight-commander", :because => "Both install a `mc` binary"

  def install
    ENV["GOPATH"] = buildpath
    src = buildpath/"src/github.com/minio/mc"
    src.install buildpath.children
    src.cd do
      if build.head?
        system "go", "build", "-o", buildpath/"mc"
      else
        minio_release = `git tag --points-at HEAD`.chomp
        minio_version = minio_release.gsub(/RELEASE\./, "").chomp.gsub(/T(\d+)\-(\d+)\-(\d+)Z/, 'T\1:\2:\3Z')
        minio_commit = `git rev-parse HEAD`.chomp
        proj = "github.com/minio/mc"

        system "go", "build", "-o", buildpath/"mc", "-ldflags", <<~EOS
          -X #{proj}/cmd.Version=#{minio_version}
          -X #{proj}/cmd.ReleaseTag=#{minio_release}
          -X #{proj}/cmd.CommitID=#{minio_commit}
        EOS
      end
    end

    bin.install buildpath/"mc"
    prefix.install_metafiles
  end

  test do
    system bin/"mc", "mb", testpath/"test"
    assert_predicate testpath/"test", :exist?
  end
end
