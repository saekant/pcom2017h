/*
 * PCoM-DB page behaviour (plain JavaScript, no jQuery).
 *
 * Everything is attached from this file instead of inline onclick="..." attributes,
 * so the site can use a strict Content Security Policy.
 */
(function () {
  "use strict";

  var MAX_GENES = 10;

  // ------------------------------------------------------------------ gene_id input
  // Same normalisation as the original site: lower-case and remove spaces.
  function normalizeGeneId(input) {
    input.value = input.value.toLowerCase().split(" ").join("").split("　").join("");
  }

  function setupGeneIdInputs() {
    document.querySelectorAll("input[data-gene-id]").forEach(function (input) {
      input.addEventListener("blur", function () { normalizeGeneId(input); });
      if (input.form) input.form.addEventListener("submit", function () { normalizeGeneId(input); });
    });
  }

  // ------------------------------------------------------------------ multiple search (max 10 IDs)
  function setupGeneListForm() {
    document.querySelectorAll("textarea[data-gene-list]").forEach(function (area) {
      area.form.addEventListener("submit", function (event) {
        var ids = area.value.split(/\r\n|\r|\n|,/).filter(function (s) { return s.trim() !== ""; });
        if (ids.length > MAX_GENES) {
          alert("A maximum of ten gene_id can be input");
          event.preventDefault();
        }
      });
    });
  }

  // ------------------------------------------------------------------ help pop-up window
  function setupHelpPopups() {
    document.querySelectorAll("a[data-popup]").forEach(function (link) {
      link.addEventListener("click", function (event) {
        event.preventDefault();
        var size = (link.getAttribute("data-popup") || "400x380").split("x");
        window.open(link.href, "help_gene_id",
          "width=" + size[0] + ",height=" + size[1] + ",menubar=no,toolbar=no,location=no");
      });
    });
  }

  // ------------------------------------------------------------------ clickable table rows
  function setupRowLinks() {
    document.querySelectorAll("tr[data-href]").forEach(function (row) {
      row.addEventListener("click", function (event) {
        if (event.target.closest("a, input, button")) return;
        window.location.href = row.getAttribute("data-href");
      });
    });
  }

  // ------------------------------------------------------------------ peak list check boxes
  function setupPeakList() {
    var form = document.getElementById("gel_no_form");
    if (!form) return;

    function boxes() { return form.querySelectorAll("input[type=checkbox]:not([disabled])"); }

    var all = document.getElementById("check_all");
    var clear = document.getElementById("check_clear");
    if (all) all.addEventListener("click", function () { boxes().forEach(function (b) { b.checked = true; }); });
    if (clear) clear.addEventListener("click", function () { boxes().forEach(function (b) { b.checked = false; }); });

    var recharts = document.getElementById("recharts_button");
    if (recharts) {
      recharts.addEventListener("click", function (event) {
        var count = form.querySelectorAll("input[type=checkbox]:checked").length;
        if (count > MAX_GENES) {
          alert("A maximum of ten gene_id can be checked.");
          event.preventDefault();
        }
      });
    }
  }

  // ------------------------------------------------------------------ migration-profile chart
  function setupChart() {
    var container = document.getElementById("chart_container");
    if (!container || typeof Highcharts === "undefined") return;

    var chartsets = JSON.parse(container.getAttribute("data-chartsets") || "[]");
    if (chartsets.length === 0) return;

    var form = document.getElementById("gel_no_form");
    var yTitle = container.getAttribute("data-mode") === "2" ? "emPAI(%)" : "emPAI";
    var categories = chartsets[0].xlist === "" ? [] : chartsets[0].xlist.split(",").map(function (s) { return s.trim(); });

    var series = chartsets.map(function (set) {
      var data = set.ylist === "" ? [] : set.ylist.split(",").map(Number);
      return { name: set.gene_id, data: data };
    });

    Highcharts.chart(container, {
      chart: { animation: false },
      title: { text: "Migration Profile" },
      xAxis: {
        title: { text: "gel_slice_number" },
        categories: categories,
        tickInterval: 5,
        tickWidth: 0,
        gridLineWidth: 1,
        crosshair: true,
        labels: { align: "left", x: 3, y: -3 }
      },
      yAxis: [
        { title: { text: yTitle }, labels: { align: "left", x: 3, y: 16 }, showFirstLabel: false },
        { linkedTo: 0, gridLineWidth: 0, opposite: true, title: { text: yTitle },
          labels: { align: "right", x: -3, y: 16 }, showFirstLabel: false }
      ],
      legend: { align: "left", verticalAlign: "top", y: 20, floating: true, borderWidth: 0 },
      credits: { enabled: false },
      accessibility: { enabled: false },
      tooltip: { shared: true },
      plotOptions: {
        series: {
          animation: false,
          cursor: "pointer",
          marker: { lineWidth: 1 },
          point: {
            events: {
              // Click a point: show the proteins found in that gel slice.
              click: function () {
                if (!form) return;
                form.elements["gel_no"].value = this.category;
                form.action = form.getAttribute("data-point-action");
                form.submit();
              }
            }
          }
        }
      },
      series: series
    });
  }

  // ------------------------------------------------------------------ sortable / paginated tables
  // A rewrite of the small "TINY.table.sorter" script used by the original site
  // (without eval / new Function, which a strict CSP would block).
  function TableSorter(table, options) {
    this.table = table;
    this.paginate = options.paginate;
    this.pageSize = 20;
    this.page = 1;
    this.sortCol = null;
    this.desc = false;
    this.current = document.getElementById("currentpage");
    this.limit = document.getElementById("pagelimit");
    var self = this;

    Array.prototype.forEach.call(table.tHead.rows[0].cells, function (cell, index) {
      if (cell.className === "nosort") return;
      cell.className = "head";
      cell.addEventListener("click", function () { self.sort(index); });
    });

    if (options.initialSort !== null) this.sort(options.initialSort);
    else this.render();
  }

  TableSorter.prototype.rows = function () { return Array.prototype.slice.call(this.table.tBodies[0].rows); };

  TableSorter.prototype.cellValue = function (row, col) {
    var cell = row.cells[col];
    return cell ? cell.textContent.trim().toLowerCase() : "";
  };

  TableSorter.prototype.compare = function (a, b) {
    var na = parseFloat(a.replace(/(\$|,)/g, "")), nb = parseFloat(b.replace(/(\$|,)/g, ""));
    if (!isNaN(na) && !isNaN(nb)) { a = na; b = nb; }
    return a > b ? 1 : (a < b ? -1 : 0);
  };

  TableSorter.prototype.sort = function (col) {
    var self = this;
    if (this.sortCol === col) this.desc = !this.desc;
    else { this.sortCol = col; this.desc = false; }

    var rows = this.rows();
    rows.sort(function (r1, r2) {
      var c = self.compare(self.cellValue(r1, col), self.cellValue(r2, col));
      return self.desc ? -c : c;
    });
    var body = this.table.tBodies[0];
    rows.forEach(function (row, i) {
      body.appendChild(row);
      row.className = i % 2 === 0 ? "evenrow" : "oddrow";
      Array.prototype.forEach.call(row.cells, function (cell, z) {
        cell.className = z === col ? (i % 2 === 0 ? "evenselected" : "oddselected") : "";
      });
    });

    Array.prototype.forEach.call(this.table.tHead.rows[0].cells, function (cell, index) {
      if (cell.className === "nosort") return;
      cell.className = index === col ? (self.desc ? "desc" : "asc") : "head";
    });

    this.page = 1;
    this.render();
  };

  TableSorter.prototype.pages = function () { return Math.max(1, Math.ceil(this.rows().length / this.pageSize)); };

  TableSorter.prototype.render = function () {
    var self = this;
    var start = (this.page - 1) * this.pageSize, end = start + this.pageSize;
    this.rows().forEach(function (row, i) {
      row.style.display = !self.paginate || (i >= start && i < end) ? "" : "none";
    });
    if (this.paginate && this.current && this.limit) {
      this.current.textContent = this.page;
      this.limit.textContent = this.pages();
    }
  };

  TableSorter.prototype.move = function (direction, toEnd) {
    var target = direction > 0 ? (toEnd ? this.pages() : this.page + 1) : (toEnd ? 1 : this.page - 1);
    if (target >= 1 && target <= this.pages()) { this.page = target; this.render(); }
  };

  TableSorter.prototype.size = function (size) {
    this.pageSize = parseInt(size, 10) || 20;
    this.page = 1;
    this.render();
  };

  function setupSorters() {
    document.querySelectorAll("table[data-sorter]").forEach(function (table) {
      var initial = table.getAttribute("data-sort-column");
      var sorter = new TableSorter(table, {
        paginate: table.getAttribute("data-paginate") === "true",
        initialSort: initial === null ? null : parseInt(initial, 10)
      });

      var perPage = document.getElementById("perpage_select");
      if (perPage) perPage.addEventListener("change", function () { sorter.size(perPage.value); });
      document.querySelectorAll("[data-page-move]").forEach(function (button) {
        button.addEventListener("click", function () {
          sorter.move(parseInt(button.getAttribute("data-page-move"), 10), button.hasAttribute("data-page-end"));
        });
      });
    });
  }

  // ------------------------------------------------------------------ image viewer (Overview page)
  function setupLightbox() {
    document.querySelectorAll("a[data-lightbox]").forEach(function (link) {
      link.addEventListener("click", function (event) {
        event.preventDefault();
        var overlay = document.createElement("div");
        overlay.className = "pcom-lightbox";
        var img = document.createElement("img");
        img.src = link.href;
        img.alt = "";
        var close = document.createElement("button");
        close.type = "button";
        close.setAttribute("aria-label", "Close");
        close.textContent = "×";
        overlay.appendChild(img);
        overlay.appendChild(close);

        function remove() {
          overlay.remove();
          document.removeEventListener("keydown", onKey);
        }
        function onKey(e) { if (e.key === "Escape") remove(); }
        overlay.addEventListener("click", remove);
        document.addEventListener("keydown", onKey);
        document.body.appendChild(overlay);
      });
    });
  }

  document.addEventListener("DOMContentLoaded", function () {
    setupGeneIdInputs();
    setupGeneListForm();
    setupHelpPopups();
    setupRowLinks();
    setupPeakList();
    setupSorters();
    setupChart();
    setupLightbox();
  });
})();
