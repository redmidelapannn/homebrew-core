class BazelAT070 < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.7.0/bazel-0.7.0-dist.zip"
  sha256 "a084a9c5d843e2343bf3f319154a48abe3d35d52feb0ad45dec427a1c4ffc416"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "7d54c3fc28077601fe52aa264787da93f7801b1dc33ea957f30186c88cc4d030" => :high_sierra
    sha256 "7ef2f35e7f99e9578c8f3124742c6e2cde5e8072d3667061ea215c8227f44c75" => :sierra
    sha256 "857f432143dc29c96cbe479c455c3599cf9e9a07583ee66e68081fc32fb74a1e" => :el_capitan
  end

  depends_on :java => "1.8"
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
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))

    bash_completion.install "bazel-bin/scripts/bazel-complete.bash"
    zsh_completion.install "scripts/zsh_completion/_bazel"
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
