class BazelAT080 < Formula
  desc "Google's own build tool"
  homepage "https://bazel.build/"
  url "https://github.com/bazelbuild/bazel/releases/download/0.8.0/bazel-0.8.0-dist.zip"
  sha256 "aa840321d056abd3c6be10c4a1e98a64f9f73fff9aa89c468dae8c003974a078"

  bottle do
    cellar :any_skip_relocation
    sha256 "071bc4053cbb8deced26cae69f5ba2ce812288fdf0af0cb26c38c9260d2c0140" => :high_sierra
    sha256 "eb2ed13d97090bb9b7848f3937e81166ad3290187842837303263a5ff63553f4" => :sierra
    sha256 "516ebb26386eaffabe8268c68c661a6f98a82ff550362be2bdab69dab479289a" => :el_capitan
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
