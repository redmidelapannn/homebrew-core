class Camlp5TransitionalModeRequirement < Requirement
  fatal true

  satisfy(:build_env => false) { !Tab.for_name("camlp5").with?("strict") }

  def message; <<-EOS.undent
    camlp5 must be compiled in transitional mode (instead of --strict mode):
      brew install camlp5
    EOS
  end
end

class Coq < Formula
  desc "Proof assistant for higher-order logic"
  homepage "https://coq.inria.fr/"
  url "https://coq.inria.fr/distrib/8.6.1/files/coq-8.6.1.tar.gz"
  sha256 "32f8aa92853483dec18030def9f0857a708fee56cf4287e39c9a260f08138f9d"
  revision 1
  head "git://scm.gforge.inria.fr/coq/coq.git"

  bottle do
    rebuild 1
    sha256 "ee03ea22e2f594b0dbf7bad9d49ed13ea32647a480337cbce33939e8d7c1c142" => :sierra
    sha256 "f05aa1bd78359c75d5ef3de810efdaf6fd54810ecd6b304b6b812a161d757e2a" => :el_capitan
    sha256 "ac925c998f734fdf3438672335cb2a366e0a0bf6e7a5e2f9ffcfe31a6920be25" => :yosemite
  end

  depends_on "opam" => :build
  depends_on Camlp5TransitionalModeRequirement
  depends_on "camlp5"
  depends_on "ocaml"

  def install
    ENV["OPAMYES"] = "1"
    opamroot = buildpath/"../opamroot"
    opamroot.mkpath
    ENV["OPAMROOT"] = opamroot
    system "opam", "init", "--no-setup"
    system "opam", "install", "ocamlfind"

    system "opam", "config", "exec", "--",
           "./configure", "-prefix", prefix,
                          "-mandir", man,
                          "-emacslib", elisp,
                          "-coqdocdir", "#{pkgshare}/latex",
                          "-coqide", "no",
                          "-with-doc", "no"
    system "make", "world"
    ENV.deparallelize { system "make", "install" }
  end

  test do
    (testpath/"testing.v").write <<-EOS.undent
      Inductive nat : Set :=
      | O : nat
      | S : nat -> nat.
      Fixpoint add (n m: nat) : nat :=
        match n with
        | O => m
        | S n' => S (add n' m)
        end.
      Lemma add_O_r : forall (n: nat), add n O = n.
      intros n; induction n; simpl; auto; rewrite IHn; auto.
      Qed.
    EOS
    system("#{bin}/coqc", "#{testpath}/testing.v")
  end
end
