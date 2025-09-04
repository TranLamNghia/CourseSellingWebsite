<script>
    (function(){
        const root = document.getElementById('toast-root');

        function makeToast({title = "Trạng thái", message = "Thông tin", type = "success", iconClass = null, duration = 3000}){
            const card = document.createElement('div');
            card.className = `toast-card toast--${type}`;

            // icon mặc định theo type (Font Awesome)
            const iconMap = {
                success: "fa-solid fa-check",
                error:   "fa-solid fa-xmark",
                warn:    "fa-solid fa-exclamation",
                info:    "fa-solid fa-info"
            };
            const icon = iconClass || iconMap[type] || iconMap.info;

            card.innerHTML = `
            <div class="circle-icon"><i class="${icon}"></i></div>
            <div class="toast-head">
                <div class="toast-pill">${title}</div>
                <button class="toast-close" aria-label="Đóng">&times;</button>
            </div>
            <div class="toast-body">${message}</div>
            <div class="toast-progress"><i style="animation-duration:${duration}ms"></i></div>
            `;

            // đóng
            const close = () => {
                card.style.animation = 'toast-fade-out .25s ease forwards';
                setTimeout(()=> card.remove(), 220);
            };
            card.querySelector('.toast-close').addEventListener('click', close);

            // auto-hide
            const timer = setTimeout(close, duration);
            card.addEventListener('mouseenter', ()=> clearTimeout(timer)); // hover to pause

            root.appendChild(card);
            return card;
        }

        // Expose global helper
        window.showToast = makeToast;
    })();
</script>
