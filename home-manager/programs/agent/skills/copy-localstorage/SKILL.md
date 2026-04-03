---
name: copy-localstorage
description: localStorage を別オリジンにコピーする手順を表示する
---

# localStorage を別オリジンにコピーする

## 手順

### Step 1: コピー元のDevConsoleで実行

```js
copy(JSON.stringify(localStorage))
```

### Step 2: コピー先のDevConsoleで実行

コンソールに `const data = ` と入力し、続けてペースト（Cmd+V）してEnterを押す。

```js
const data = /* ここにペーストされる */
```

### Step 3: localStorage に書き込んでリロード

```js
Object.entries(data).forEach(([k, v]) => localStorage.setItem(k, v));
location.reload();
```
