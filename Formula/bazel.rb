class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.17.1/bazel-0.17.1-dist.zip"
  sha256 "23e4281c3628cbd746da3f51330109bbf69780bd64461b63b386efae37203f20"

  bottle do
    cellar :any_skip_relocation
    sha256 "91cd7982b3aa0a604ac5c014b6c18ae9998e133df4a628e7e17b6d399cd97d23" => :mojave
    sha256 "79de825d5a43a641ddbdaa486a8678601287a2291af36f66ebb1bd8e58ab129b" => :high_sierra
    sha256 "58efb3f2da1b6f7b20e5b410ec76a023afa2ea3e8ccaa307b0d9a0ef76ba18fb" => :sierra
  end

  depends_on :java => "1.8"
  depends_on :macos => :yosemite

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    (buildpath/"sources").install buildpath.children

    cd "sources" do
      system "./compile.sh"
      system "./output/bazel", "--output_user_root",
             buildpath/"output_user_root", "build", "scripts:bash_completion"

      bin.install "scripts/packages/bazel.sh" => "bazel"
      bin.install "output/bazel" => "bazel-real"
      bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))

      bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
      zsh_completion.install "scripts/zsh_completion/_bazel"

      prefix.install_metafiles
    end
  end

  test do
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<~EOS
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    EOS

    (testpath/"BUILD").write <<~EOS
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    EOS

    system bin/"bazel", "build", "//:bazel-test"
    system "bazel-bin/bazel-test"
  end
end
