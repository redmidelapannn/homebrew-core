class Bazel < Formula
  desc "Google's own build tool"
  homepage "http://www.bazel.io/"
  url "https://github.com/bazelbuild/bazel/archive/0.2.3.tar.gz"
  sha256 "7e48bf3ef6da3afe619305708bfa09dde7f475ab8f1c3732faa0210a9b55c018"
  head "https://github.com/bazelbuild/bazel.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "d40dd768560ff9a92b4888e99aaef494d298c80d5c462d9012317c4bf5a123ad" => :el_capitan
    sha256 "b9fa14175dfb4012e8b431a8a90a1b45f2eaa58a953fe13969eaba42bce6c553" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"

    system "./compile.sh"
    system "./output/bazel", "build", "scripts:bash_completion"

    bin.install "output/bazel" => "bazel"
    bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
    zsh_completion.install "scripts/zsh_completion/_bazel"
  end

  test do
    touch testpath/"WORKSPACE"

    (testpath/"ProjectRunner.java").write <<-EOS.undent
      public class ProjectRunner {
        public static void main(String args[]) {
          System.out.println("Hi!");
        }
      }
    EOS

    (testpath/"BUILD").write <<-EOS.undent
      java_binary(
        name = "bazel-test",
        srcs = glob(["*.java"]),
        main_class = "ProjectRunner",
      )
    EOS

    system "#{bin}/bazel", "build", "//:bazel-test"
    system "bazel-bin/bazel-test"
  end
end
