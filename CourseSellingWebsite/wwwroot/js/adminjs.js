async function loadComponent(url, elementId) {
    try {
        const response = await fetch(url)
        const html = await response.text()
        document.getElementById(elementId).innerHTML = html
        // Re-attach event listeners if necessary for loaded components
        if (elementId === "sidebar") {
            setupSidebarToggle()
            setupNavLinks()
        }
        if (elementId === "mainHeader") {
            setupDropdowns()
        }
    } catch (error) {
        console.error("Error loading component:", url, error)
    }
}

async function loadPage(pageName) {
    const pageUrl = `/admin/pages/${pageName}.html`
    try {
        const response = await fetch(pageUrl)
        const html = await response.text()
        document.getElementById("contentBody").innerHTML = html
        updatePageTitle(pageName)
        updateActiveNavItem(pageName)
        // Re-attach event listeners for the newly loaded page content
        setupTabButtons()
        setupSearchInputs()
    } catch (error) {
        console.error("Error loading page:", pageUrl, error)
        document.getElementById("contentBody").innerHTML =
            '<div class="empty-state"><i class="fas fa-exclamation-triangle"></i><h3>Trang không tìm thấy</h3><p>Nội dung trang bạn yêu cầu không tồn tại.</p></div>'
        updatePageTitle("Lỗi")
    }
}

function updatePageTitle(pageName) {
    const titles = {
        dashboard: "Dashboard",
        teachers: "Quản Lý Giáo Viên",
        students: "Quản Lý Học Sinh",
        courses: "Quản Lý Khóa Học",
        statistics: "Thống Kê",
        sales: "Báo Cáo Doanh Số",
        settings: "Cài Đặt",
        "": "Dashboard", // Default for empty hash
    }
    const pageTitleElement = document.getElementById("pageTitle")
    if (pageTitleElement) {
        pageTitleElement.textContent = titles[pageName] || "Dashboard"
    }
}

function updateActiveNavItem(pageName) {
    document.querySelectorAll(".nav-item").forEach((item) => {
        item.classList.remove("active")
    })
    const activeItem = document.querySelector(`.nav-item a[href="#${pageName}"]`)
    if (activeItem) {
        activeItem.parentElement.classList.add("active")
    }
}

// Functions to be called after content is loaded
function setupSidebarToggle() {
    const toggleBtn = document.getElementById("toggleSidebar")
    const sidebar = document.getElementById("sidebar")
    const mainContent = document.querySelector(".main-content")
    if (toggleBtn && sidebar && mainContent) {
        toggleBtn.onclick = () => {
            sidebar.classList.toggle("collapsed")
            mainContent.classList.toggle("sidebar-collapsed") // Add a class to main-content for margin adjustment
        }
    }
}

function setupNavLinks() {
    document.querySelectorAll(".nav-menu .nav-link").forEach((link) => {
        link.onclick = (e) => {
            e.preventDefault()
            const page = link.getAttribute("href").substring(1)
            window.location.hash = page // Update hash to trigger hashchange event
        }
    })
}

function setupDropdowns() {
    const dropdownBtn = document.querySelector(".admin-profile .dropdown-btn")
    const dropdownMenu = document.querySelector(".admin-profile .dropdown-menu")
    if (dropdownBtn && dropdownMenu) {
        dropdownBtn.onclick = (e) => {
            e.stopPropagation()
            dropdownMenu.classList.toggle("show")
        }
        document.addEventListener("click", (event) => {
            if (!dropdownBtn.contains(event.target) && !dropdownMenu.contains(event.target)) {
                dropdownMenu.classList.remove("show")
            }
        })
    }
}

function setupTabButtons() {
    document.querySelectorAll(".tab-buttons .tab-btn").forEach((btn) => {
        btn.onclick = () => {
            const tabId = btn.dataset.tab
            const parentContainer = btn.closest(".page-content")
            if (parentContainer) {
                parentContainer.querySelectorAll(".tab-btn").forEach((b) => b.classList.remove("active"))
                btn.classList.add("active")
                parentContainer.querySelectorAll(".tab-content").forEach((content) => content.classList.remove("active"))
                document.getElementById(tabId).classList.add("active")
            }
        }
    })
}

function setupSearchInputs() {
    document.querySelectorAll('[placeholder*="Tìm kiếm"]').forEach((input) => {
        input.oninput = (e) => {
            const searchTerm = e.target.value.toLowerCase()
            const tableBody = e.target.closest(".tab-content, .page-content")?.querySelector("tbody") // Search within closest tab-content or page-content
            if (tableBody) {
                const rows = tableBody.querySelectorAll("tr")
                rows.forEach((row) => {
                    const text = row.textContent.toLowerCase()
                    row.style.display = text.includes(searchTerm) ? "" : "none"
                })
            }
        }
    })
}
