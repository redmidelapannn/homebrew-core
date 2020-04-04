class MinioMc < Formula
  desc "Replacement for ls, cp and other commands for object storage"
  homepage "https://github.com/minio/mc"
  url "https://github.com/minio/mc.git",
      :tag      => "RELEASE.2020-04-04T05-28-55Z",
      :revision => "8cae137525a4ae986a1701b7ce3a3f5f065dfa31"
  version "20200404052855"

  bottle do
    cellar :any_skip_relocation
    sha256 "0e16bf7683aee439abb009acd620c4f3ecb136cc81dc3b889437265e26c76415" => :catalina
    sha256 "851f0c9065a0d17c3b46a276c6532f669b8f58930bc9f3d8207635d29d915083" => :mojave
    sha256 "361d591c5314a40db1fc2cafa500dd4d458aeb82eb1accb65592af6bd00b0d30" => :high_sierra
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
