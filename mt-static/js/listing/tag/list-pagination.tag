<list-pagination>
  <div class={
    col-auto: true,
    mx-auto: true,
    w-100: hasMoreThanFivePages()
  }>
    <nav aria-label={ store.listClient.objectType + ' list' }>
      <virtual data-is="list-pagination-for-pc"></virtual>
      <virtual data-is="list-pagination-for-mobile"></virtual>
    </nav>
  </div>

  <script>
    riot.mixin('listPagination', {
      hasMoreThanFivePages: function () {
        return this.store.pageMax >= 5;
      },
      movePage: function (e) {
        if (e.currentTarget.disabled) {
            return false
        }

        var nextPage
        if (e.target.tagName == "INPUT") {
            if (e.which != 13) {
            return false
            }
            nextPage = Number(e.target.value)
        } else {
            nextPage = Number(e.currentTarget.dataset.page)
        }
        if (!nextPage) {
            return false
        }
        var moveToPagination = true
        this.store.trigger('move_page', nextPage, moveToPagination)
        return false
      }
    })

    this.mixin('listTop')
    this.mixin('listPagination')
  </script>
</list-pagination>
