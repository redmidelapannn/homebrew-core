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
  head "git://scm.gforge.inria.fr/coq/coq.git", :branch => "trunk"

  bottle do
    rebuild 1
    sha256 "8174eb0e16839f32827219ed34003e7a6c9499a1527b84d7dd0e94f6d327f4b5" => :sierra
    sha256 "a9502ff3ee34282f1561d9b298c4838da6e686cc8c74b76584e1efa0a92a4b41" => :el_capitan
    sha256 "5ada9e5c96c448f02a8e9f0805437325f044c9c802ddd536a460ee9994170b9a" => :yosemite
  end

  depends_on "opam" => :build
  depends_on Camlp5TransitionalModeRequirement
  depends_on "camlp5"
  depends_on "ocaml"

  def install
    ENV["OPAMYES"] = "1"
    ENV["OPAMROOT"] = Pathname.pwd/"opamroot"
    (Pathname.pwd/"opamroot").mkpath
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
      Require Coq.omega.Omega.
      Require Coq.ZArith.ZArith.

      Inductive nat : Set :=
      | O : nat
      | S : nat -> nat.
      Fixpoint add (n m: nat) : nat :=
        match n with
        | O => m
        | S n' => S (add n' m)
        end.
      Lemma add_O_r : forall (n: nat), add n O = n.
      Proof.
      intros n; induction n; simpl; auto; rewrite IHn; auto.
      Qed.

      Import Coq.omega.Omega.
      Import Coq.ZArith.ZArith.
      Open Scope Z.
      Lemma add_O_r_Z : forall (n: Z), n + 0 = n.
      Proof.
      intros; omega.
      Qed.
    EOS
    system("#{bin}/coqc", "#{testpath}/testing.v")
  end
end
