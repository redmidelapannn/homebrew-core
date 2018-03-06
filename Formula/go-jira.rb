class GoJira < Formula
  desc "Simple jira command-line client in Go"
  homepage "https://github.com/Netflix-Skunkworks/go-jira"
  url "https://github.com/Netflix-Skunkworks/go-jira/archive/v1.0.14.tar.gz"
  sha256 "34cb45af19985474b8d9079c1f551f4892bfbe64073a5a8f89333ca3603e4639"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "0c1c6afad6b1d519925557e60ad9a05983c4c23bc35294c2b3d018975edf31af" => :high_sierra
    sha256 "d2a88a1545c4e64fc68ba843a4c509977acb5292d9747b933d29bf090b9616c4" => :sierra
    sha256 "fa9ac035f3df337690ec4eee54bc1b1f14b8b4991015e60c6d1254580ae9e5d0" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/gopkg.in/Netflix-Skunkworks/go-jira.v1"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"jira", "-ldflags", "-w -s", "cmd/jira/main.go"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/jira", "export-templates"
    template_dir = testpath/".jira.d/templates/"

    files = Dir.entries(template_dir)
    # not an exhaustive list, see https://github.com/Netflix-Skunkworks/go-jira/blob/4d74554300fa7e5e660cc935a92e89f8b71012ea/jiracli/templates.go#L239
    expected_templates = %w[comment components create edit issuetypes list view worklog debug]

    assert_equal([], expected_templates - files)
    assert_equal("{{ . | toJson}}\n", IO.read("#{template_dir}/debug"))
  end
end
