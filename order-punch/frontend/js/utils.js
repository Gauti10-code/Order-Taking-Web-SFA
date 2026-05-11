const API = "http://localhost:8000";

// ── Auth helpers ──────────────────────────────────────────────────────────
function getToken() { return localStorage.getItem("token"); }
function getRole()  { return localStorage.getItem("role"); }
function getName()  { return localStorage.getItem("name"); }

function requireAuth() {
  if (!getToken()) { window.location.href = "pages/login.html"; return false; }
  return true;
}

function logout() {
  localStorage.clear();
  window.location.href = "pages/login.html";
}

// ── Fetch wrapper ─────────────────────────────────────────────────────────
async function apiFetch(path, opts = {}) {
  const headers = { "Content-Type": "application/json", ...opts.headers };
  if (getToken()) headers["Authorization"] = `Bearer ${getToken()}`;
  const res = await fetch(`${API}${path}`, { ...opts, headers });
  if (res.status === 401) { logout(); return null; }
  return res;
}

// ── Toast ─────────────────────────────────────────────────────────────────
function toast(msg, type = "info") {
  let container = document.getElementById("toast-container");
  if (!container) {
    container = document.createElement("div");
    container.id = "toast-container";
    document.body.appendChild(container);
  }
  const t = document.createElement("div");
  t.className = `toast toast-${type}`;
  t.textContent = msg;
  container.appendChild(t);
  setTimeout(() => t.remove(), 3000);
}

// ── Navigation ────────────────────────────────────────────────────────────
function showPage(id) {
  document.querySelectorAll(".page").forEach(p => p.classList.remove("active"));
  document.querySelectorAll(".nav-item").forEach(n => n.classList.remove("active"));
  const page = document.getElementById(`page-${id}`);
  const nav  = document.querySelector(`[data-page="${id}"]`);
  if (page) page.classList.add("active");
  if (nav)  nav.classList.add("active");
}

// ── Modal helpers ─────────────────────────────────────────────────────────
function openModal(id) { document.getElementById(id).classList.remove("hidden"); }
function closeModal(id) { document.getElementById(id).classList.add("hidden"); }
