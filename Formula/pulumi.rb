class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v1.1.0",
      :revision => "5af13f9a4f750c6ff3234dae6fedd0b6a0233e25"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "a6f67d795e4536f613b63b9aa7d79b4485815280f12a41a2b8e1c9eaff12e94f" => :mojave
    sha256 "aef7996c025c339b519ef09945977c6394045aa851f9cbcd50bbf2f0b4f8fdd0" => :high_sierra
    sha256 "c0966b31acf00b622413863d87bce3083a6a4a0c92b4bea43d1c424ec764fdd6" => :sierra
  end

  depends_on "go@1.12" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/pulumi/pulumi"
    dir.install buildpath.children

    cd dir do
      system "go", "mod", "vendor"
      system "make", "dist"
      bin.install Dir["#{buildpath}/bin/*"]
      prefix.install_metafiles

      # Install bash completion
      output = Utils.popen_read("#{bin}/pulumi gen-completion bash")
      (bash_completion/"pulumi").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/pulumi gen-completion zsh")
      (zsh_completion/"_pulumi").write output
    end
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
