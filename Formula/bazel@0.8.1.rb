class BazelAT081 < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.8.1/bazel-0.8.1-dist.zip"
  sha256 "dfd0761e0b7e36c1d74c928ad986500c905be5ebcfbc29914d574af1db7218cf"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5ef76b8a8538f5ea63ddfa75b4f8bf58af86a0defdd65d50050e58e6703a036" => :high_sierra
    sha256 "3960f67e1c4975dad98037be49850c1ee7fbf9d4e9354d95a59ae37d815efdb5" => :sierra
    sha256 "53ea7fdc6dbeff46c9ab7b729f2a90df7fd891fdef10d102afcb74822edacdf6" => :el_capitan
  end

  keg_only :versioned_formula
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
