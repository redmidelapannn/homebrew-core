class Bazel < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.4.4/bazel-0.4.4-dist.zip"
  sha256 "d52a21dda271ae645711ce99c70cf44c5d3a809138e656bbff00998827548ebb"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "6382233307e0b7592af6a9c25a48cb74b6a767ff3d18acff370893f736fadc6b" => :sierra
    sha256 "5c174676f5143c128fedf4f63ae4b011250ec6903bb2acdd5334090367ac1904" => :el_capitan
    sha256 "9a1de7e40b326105cafc543f81112bf1d79cffdcf16e6bae5d40f0f63b2ef67f" => :yosemite
  end

  depends_on :java => "1.8+"
  depends_on :macos => :yosemite

  def install
    ENV["EMBED_LABEL"] = "#{version}-homebrew"
    # Force Bazel ./compile.sh to put its temporary files in the buildpath
    ENV["BAZEL_WRKDIR"] = buildpath/"work"

    system "./compile.sh"
    system "./output/bazel", "--output_user_root", buildpath/"output_user_root",
           "build", "scripts:bash_completion"

    bin.install "scripts/packages/bazel.sh" => "bazel"
    bin.install "output/bazel" => "bazel-real"
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

    system bin/"bazel", "build", "//:bazel-test"
    system "bazel-bin/bazel-test"
  end
end
